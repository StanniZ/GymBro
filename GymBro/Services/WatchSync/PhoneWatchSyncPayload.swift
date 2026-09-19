//
//  PhoneWatchSyncPayload.swift
//  GymBro
//
//  Created by Codex on 15/09/2026.
//

import Foundation

enum PhoneWatchSyncMessageKey {
    nonisolated static let type = "type"
    nonisolated static let payload = "payload"
}

enum PhoneWatchSyncMessageType {
    static let templatesSnapshot = "templates_snapshot"
    static let workoutCompleted = "workout_completed"
    static let requestTemplates = "request_templates"
}

struct PhoneWatchTemplatesSnapshotPayload: Codable, Equatable {
    let templates: [PhoneWatchWorkoutTemplatePayload]
    let generatedAt: Date
}

struct PhoneWatchWorkoutTemplatePayload: Codable, Equatable, Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let exercises: [PhoneWatchExercisePlanPayload]
}

struct PhoneWatchExercisePlanPayload: Codable, Equatable, Identifiable {
    let id: UUID
    let exerciseID: Int
    let name: String
    let muscleGroup: String
    let targetSets: Int
    let defaultWeight: Double
    let defaultReps: Int
}

struct PhoneWatchFinishedWorkoutPayload: Codable, Equatable {
    let id: UUID
    let title: String
    let startedAt: Date
    let finishedAt: Date
    let activeCalories: Int?
    let exercises: [PhoneWatchFinishedExercisePayload]
}

struct PhoneWatchFinishedExercisePayload: Codable, Equatable, Identifiable {
    let id: UUID
    let exerciseID: Int
    let name: String
    let muscleGroup: String
    let isFinished: Bool
    let sets: [PhoneWatchFinishedSetPayload]
}

struct PhoneWatchFinishedSetPayload: Codable, Equatable, Identifiable {
    let id: UUID
    let setNumber: Int
    let weight: Double
    let reps: Int
    let isCompleted: Bool
}
