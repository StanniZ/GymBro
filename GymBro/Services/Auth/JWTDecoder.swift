//
//  JWTDecoder.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import Foundation

enum JWTDecoder {
    struct Payload: Decodable, Equatable {
        let exp: TimeInterval?
        let sub: String?
        let userID: UUID?

        enum CodingKeys: String, CodingKey {
            case exp
            case sub
            case userID = "user_id"
        }
    }

    static func payload(from token: String) -> Payload? {
        let segments = token.split(separator: ".")
        guard segments.count >= 2 else { return nil }

        var base64 = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let paddingLength = 4 - base64.count % 4
        if paddingLength < 4 {
            base64.append(String(repeating: "=", count: paddingLength))
        }

        guard let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONDecoder().decode(Payload.self, from: data)
    }

    static func isExpired(_ token: String, now: Date = Date()) -> Bool {
        guard let expiration = payload(from: token)?.exp else { return false }
        return Date(timeIntervalSince1970: expiration) <= now
    }
}
