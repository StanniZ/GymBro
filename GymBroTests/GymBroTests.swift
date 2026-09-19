//
//  GymBroTests.swift
//  GymBroTests
//
//  Created by macbook on 16/09/2026.
//

import Foundation
import Testing
@testable import GymBro

struct GymBroTests {

    @Test func appleNonceHasRequestedLengthAndAllowedCharacters() throws {
        let nonce = try AppleNonceGenerator.randomNonceString(length: 64)
        let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        #expect(nonce.count == 64)
        #expect(nonce.rangeOfCharacter(from: allowedCharacters.inverted) == nil)
    }

    @Test func appleNonceSHA256UsesLowercaseHexDigest() {
        let digest = AppleNonceGenerator.sha256("gymbro")

        #expect(digest == "685e38e19af4937c65493e4d5b6e96349bddc78dc9e62829a361c2549a18ba03")
        #expect(digest.count == 64)
    }

    @Test func appleAuthRequestEncodesBackendContractKeys() throws {
        let request = AppleAuthRequest(
            identityToken: "identity-token",
            rawNonce: "raw-nonce",
            displayName: "Test User"
        )

        let data = try JSONEncoder().encode(request)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: String])

        #expect(object["identity_token"] == "identity-token")
        #expect(object["raw_nonce"] == "raw-nonce")
        #expect(object["display_name"] == "Test User")
    }

    @Test func appleAuthResponseDecodesBackendContractKeys() throws {
        let userID = UUID(uuidString: "11111111-2222-3333-4444-555555555555")!
        let data = """
        {
            "access_token": "jwt-token",
            "token_type": "bearer",
            "user_id": "\(userID.uuidString)"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(AppleAuthResponse.self, from: data)

        #expect(response.accessToken == "jwt-token")
        #expect(response.tokenType == "bearer")
        #expect(response.userID == userID)
    }

    @Test func jwtDecoderReadsUnpaddedBase64URLPayloadAndExpiration() throws {
        let futureExpiration = Date(timeIntervalSince1970: 4_102_444_800)
        let token = makeJWT(payload: [
            "exp": Int(futureExpiration.timeIntervalSince1970),
            "sub": "apple-user",
            "user_id": "11111111-2222-3333-4444-555555555555"
        ])

        let payload = try #require(JWTDecoder.payload(from: token))

        #expect(payload.exp == futureExpiration.timeIntervalSince1970)
        #expect(payload.sub == "apple-user")
        #expect(payload.userID == UUID(uuidString: "11111111-2222-3333-4444-555555555555"))
        #expect(JWTDecoder.isExpired(token, now: Date(timeIntervalSince1970: 1_800_000_000)) == false)
    }

    @Test func jwtDecoderDetectsExpiredToken() {
        let token = makeJWT(payload: ["exp": 1_700_000_000])

        #expect(JWTDecoder.isExpired(token, now: Date(timeIntervalSince1970: 1_800_000_000)))
    }

    @Test func watchFinishedWorkoutPayloadMapsToFinishedTrainingSession() throws {
        let workoutID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let exerciseID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        let setID = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
        let startedAt = Date(timeIntervalSince1970: 1_800_000_000)
        let finishedAt = startedAt.addingTimeInterval(42 * 60)
        let payload = PhoneWatchFinishedWorkoutPayload(
            id: workoutID,
            title: "Push Day",
            startedAt: startedAt,
            finishedAt: finishedAt,
            activeCalories: 220,
            exercises: [
                PhoneWatchFinishedExercisePayload(
                    id: exerciseID,
                    exerciseID: 12,
                    name: "Bench Press",
                    muscleGroup: "Chest",
                    isFinished: true,
                    sets: [
                        PhoneWatchFinishedSetPayload(
                            id: setID,
                            setNumber: 1,
                            weight: 80.5,
                            reps: 8,
                            isCompleted: true
                        )
                    ]
                )
            ]
        )

        let session = PhoneWatchWorkoutMapper.makeTrainingSession(from: payload)

        #expect(session.id == workoutID)
        #expect(session.name == "Push Day")
        #expect(session.durationMinutes == 42)
        #expect(session.calories == 220)
        #expect(session.isFinished)
        #expect(session.finishedAt == finishedAt)
        #expect(session.exercises.first?.exerciseID == 12)
        #expect(session.exercises.first?.sets.first?.weightKg == 80.5)
        #expect(session.exercises.first?.sets.first?.timestamp == finishedAt)
    }

    private func makeJWT(payload: [String: Any]) -> String {
        let headerData = try! JSONSerialization.data(withJSONObject: ["alg": "none", "typ": "JWT"])
        let payloadData = try! JSONSerialization.data(withJSONObject: payload)
        return [headerData, payloadData, Data()].map(base64URLEncoded).joined(separator: ".")
    }

    private func base64URLEncoded(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
