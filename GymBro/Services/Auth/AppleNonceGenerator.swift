//
//  AppleNonceGenerator.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import CryptoKit
import Foundation
import Security

enum AppleNonceGenerator {
    private static let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

    static func randomNonceString(length: Int = 32) throws -> String {
        precondition(length > 0)

        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            var randomBytes = [UInt8](repeating: 0, count: 16)
            let status = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)

            guard status == errSecSuccess else {
                throw AuthError.backend("Could not generate a secure sign in nonce.")
            }

            for randomByte in randomBytes where remainingLength > 0 {
                if randomByte < charset.count {
                    result.append(charset[Int(randomByte)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.map { String(format: "%02x", $0) }.joined()
    }
}
