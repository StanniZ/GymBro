//
//  AuthSession.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import AuthenticationServices
import Foundation

@MainActor
final class AuthSession: ObservableObject {
    enum State: Equatable {
        case anonymous
        case signingIn
        case authenticated(AuthAccount)
        case failed(String)
    }

    @Published private(set) var state: State = .anonymous

    private let tokenStore: AuthTokenStore
    private let authAPI: GymBroAuthAPI
    private var currentNonce: String?

    var isAuthenticated: Bool {
        if case .authenticated = state { return true }
        return false
    }

    var isSigningIn: Bool {
        state == .signingIn
    }

    var accountDescription: String {
        switch state {
        case .authenticated(let account):
            return account.userID?.uuidString ?? "Signed in with Apple"
        case .signingIn:
            return "Signing in..."
        case .failed(let message):
            return message
        case .anonymous:
            return "Anonymous mode"
        }
    }

    init(
        tokenStore: AuthTokenStore = KeychainAuthTokenStore(),
        authAPI: GymBroAuthAPI = URLSessionGymBroAuthAPI()
    ) {
        self.tokenStore = tokenStore
        self.authAPI = authAPI
        restoreSession()
    }

    func configureAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        do {
            let rawNonce = try AppleNonceGenerator.randomNonceString()
            currentNonce = rawNonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = AppleNonceGenerator.sha256(rawNonce)
        } catch {
            currentNonce = nil
            state = .failed(AuthError.backend("Could not prepare Apple sign in.").localizedDescription)
        }
    }

    func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>) async -> Bool {
        guard !isSigningIn else { return false }

        switch result {
        case .success(let authorization):
            state = .signingIn
            return await completeAppleSignIn(with: authorization)

        case .failure(let error):
            currentNonce = nil
            let authError = normalizedAuthorizationError(error)
            if authError == .cancelled {
                state = .anonymous
            } else {
                state = .failed(authError.localizedDescription)
            }
            return false
        }
    }

    func signOut() {
        try? tokenStore.deleteAccessToken()
        currentNonce = nil
        state = .anonymous
    }

    func clearUnauthorizedSession() {
        try? tokenStore.deleteAccessToken()
        currentNonce = nil
        state = .anonymous
    }

    func restoreSession() {
        do {
            guard let token = try tokenStore.loadAccessToken() else {
                state = .anonymous
                return
            }

            if JWTDecoder.isExpired(token) {
                try? tokenStore.deleteAccessToken()
                state = .anonymous
                return
            }

            let payload = JWTDecoder.payload(from: token)
            let userID = payload?.userID ?? payload?.sub.flatMap(UUID.init(uuidString:))
            state = .authenticated(AuthAccount(accessToken: token, userID: userID))
        } catch {
            state = .anonymous
        }
    }

    private func completeAppleSignIn(with authorization: ASAuthorization) async -> Bool {
        do {
            guard let rawNonce = currentNonce else {
                throw AuthError.missingNonce
            }

            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                throw AuthError.invalidCredential
            }

            guard let identityToken = credential.identityToken,
                  let identityTokenString = String(data: identityToken, encoding: .utf8),
                  !identityTokenString.isEmpty else {
                throw AuthError.malformedIdentityToken
            }

            let backendRequest = AppleAuthRequest(
                identityToken: identityTokenString,
                rawNonce: rawNonce,
                displayName: formattedFullName(from: credential.fullName)
            )
            let response = try await authAPI.signInWithApple(backendRequest)

            try tokenStore.saveAccessToken(response.accessToken)
            currentNonce = nil
            state = .authenticated(AuthAccount(accessToken: response.accessToken, userID: response.userID))
            return true
        } catch let error as AuthError {
            handleSignInFailure(error)
            return false
        } catch {
            handleSignInFailure(.backend("Apple sign in failed. Please try again."))
            return false
        }
    }

    private func handleSignInFailure(_ error: AuthError) {
        currentNonce = nil

        if error == .unauthorized || error == .expiredToken {
            clearUnauthorizedSession()
            return
        }

        let message = error.localizedDescription
        if !message.isEmpty {
            state = .failed(message)
        } else {
            state = .anonymous
        }
    }

    private func formattedFullName(from components: PersonNameComponents?) -> String? {
        guard let components else { return nil }

        let formatter = PersonNameComponentsFormatter()
        let fullName = formatter.string(from: components).trimmingCharacters(in: .whitespacesAndNewlines)
        return fullName.isEmpty ? nil : fullName
    }

    private func normalizedAuthorizationError(_ error: Error) -> AuthError {
        guard let authorizationError = error as? ASAuthorizationError else {
            return .backend(error.localizedDescription)
        }

        switch authorizationError.code {
        case .canceled:
            return .cancelled
        case .invalidResponse:
            return .invalidCredential
        default:
            return .backend("Apple sign in failed. Please try again.")
        }
    }
}
