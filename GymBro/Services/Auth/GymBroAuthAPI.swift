//
//  GymBroAuthAPI.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import Foundation

protocol GymBroAuthAPI {
    func signInWithApple(_ request: AppleAuthRequest) async throws -> AppleAuthResponse
}

struct URLSessionGymBroAuthAPI: GymBroAuthAPI {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(
        baseURL: URL = AppConfig.API.baseURL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    func signInWithApple(_ request: AppleAuthRequest) async throws -> AppleAuthResponse {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent("auth/apple"))
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.backend("Invalid backend response.")
        }

        switch httpResponse.statusCode {
        case 200..<300:
            do {
                return try decoder.decode(AppleAuthResponse.self, from: data)
            } catch {
                throw AuthError.backend("Backend returned malformed auth data.")
            }
        case 401:
            throw AuthError.unauthorized
        default:
            throw AuthError.backend("Backend sign in failed. Please try again.")
        }
    }
}
