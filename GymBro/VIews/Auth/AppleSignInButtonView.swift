//
//  AppleSignInButtonView.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import AuthenticationServices
import SwiftUI

struct AppleSignInButtonView: View {
    @EnvironmentObject private var authSession: AuthSession

    let onSuccess: () -> Void

    init(onSuccess: @escaping () -> Void = {}) {
        self.onSuccess = onSuccess
    }

    var body: some View {
        ZStack {
            SignInWithAppleButton(.signIn) { request in
                authSession.configureAppleSignInRequest(request)
            } onCompletion: { result in
                Task {
                    if await authSession.handleAppleSignInResult(result) {
                        onSuccess()
                    }
                }
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 50)
            .clipShape(Capsule())
            .disabled(authSession.isSigningIn)
            .opacity(authSession.isSigningIn ? 0.55 : 1.0)

            if authSession.isSigningIn {
                ProgressView()
                    .tint(.black)
            }
        }
        .shadow(color: Color.white.opacity(0.2), radius: 0.3, x: 2, y: -1)
        .accessibilityLabel("Sign in with Apple")
    }
}
