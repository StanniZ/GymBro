//
//  AuthModels.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import Foundation

struct AppleAuthRequest: Encodable, Equatable {
    let identityToken: String
    let rawNonce: String
    let displayName: String?

    enum CodingKeys: String, CodingKey {
        case identityToken = "identity_token"
        case rawNonce = "raw_nonce"
        case displayName = "display_name"
    }
}

struct AppleAuthResponse: Decodable, Equatable {
    let accessToken: String
    let tokenType: String
    let userID: UUID

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case userID = "user_id"
    }
}

struct AuthAccount: Equatable {
    let accessToken: String
    let userID: UUID?
}

enum AuthError: LocalizedError, Equatable {
    case cancelled
    case missingNonce
    case invalidCredential
    case malformedIdentityToken
    case backend(String)
    case expiredToken
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .cancelled:
            return nil
        case .missingNonce:
            return "Sign in could not be completed. Please try again."
        case .invalidCredential:
            return "Apple returned invalid credentials."
        case .malformedIdentityToken:
            return "Apple returned an invalid identity token."
        case .backend(let message):
            return message
        case .expiredToken, .unauthorized:
            return "Your session expired. Please sign in again."
        }
    }
}
