//
//  WatchWorkoutSyncPayload.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation

enum WatchSyncMessageKey {
    nonisolated static let type = "type"
    nonisolated static let payload = "payload"
}

enum WatchSyncMessageType {
    nonisolated static let templatesSnapshot = "templates_snapshot"
    nonisolated static let workoutCompleted = "workout_completed"
    nonisolated static let requestTemplates = "request_templates"
}

struct WatchTemplatesSnapshotPayload: Codable, Equatable {
    let templates: [WatchWorkoutTemplatePayload]
    let generatedAt: Date
}

struct WatchWorkoutTemplatePayload: Codable, Equatable, Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let exercises: [WatchExercisePlanPayload]
}

struct WatchExercisePlanPayload: Codable, Equatable, Identifiable {
    let id: UUID
    let exerciseID: Int
    let name: String
    let muscleGroup: String
    let targetSets: Int
    let defaultWeight: Double
    let defaultReps: Int
}

struct WatchFinishedWorkoutPayload: Codable, Equatable {
    let id: UUID
    let title: String
    let startedAt: Date
    let finishedAt: Date
    let activeCalories: Int?
    let exercises: [WatchFinishedExercisePayload]
}

struct WatchFinishedExercisePayload: Codable, Equatable, Identifiable {
    let id: UUID
    let exerciseID: Int
    let name: String
    let muscleGroup: String
    let isFinished: Bool
    let sets: [WatchFinishedSetPayload]
}

struct WatchFinishedSetPayload: Codable, Equatable, Identifiable {
    let id: UUID
    let setNumber: Int
    let weight: Double
    let reps: Int
    let isCompleted: Bool
}

extension WatchWorkoutTemplate {
    nonisolated init(payload: WatchWorkoutTemplatePayload) {
        self.init(
            id: payload.id,
            title: payload.title,
            subtitle: payload.subtitle,
            estimatedMinutes: payload.estimatedMinutes,
            exercises: payload.exercises.map(WatchExercisePlan.init(payload:))
        )
    }

    var payload: WatchWorkoutTemplatePayload {
        WatchWorkoutTemplatePayload(
            id: id,
            title: title,
            subtitle: subtitle,
            estimatedMinutes: estimatedMinutes,
            exercises: exercises.map(\.payload)
        )
    }
}

extension WatchExercisePlan {
    nonisolated init(payload: WatchExercisePlanPayload) {
        self.init(
            id: payload.id,
            exerciseID: payload.exerciseID,
            name: payload.name,
            muscleGroup: payload.muscleGroup,
            targetSets: payload.targetSets,
            defaultWeight: payload.defaultWeight,
            defaultReps: payload.defaultReps
        )
    }

    var payload: WatchExercisePlanPayload {
        WatchExercisePlanPayload(
            id: id,
            exerciseID: exerciseID,
            name: name,
            muscleGroup: muscleGroup,
            targetSets: targetSets,
            defaultWeight: defaultWeight,
            defaultReps: defaultReps
        )
    }
}

extension WatchWorkoutSession {
    func finishedPayload(finishedAt: Date = Date(), activeCalories: Int? = nil) -> WatchFinishedWorkoutPayload {
        WatchFinishedWorkoutPayload(
            id: id,
            title: title,
            startedAt: startedAt,
            finishedAt: finishedAt,
            activeCalories: activeCalories,
            exercises: exercises.map { exercise in
                WatchFinishedExercisePayload(
                    id: exercise.id,
                    exerciseID: exercise.exerciseID,
                    name: exercise.name,
                    muscleGroup: exercise.muscleGroup,
                    isFinished: exercise.isFinished,
                    sets: exercise.sets.map { set in
                        WatchFinishedSetPayload(
                            id: set.id,
                            setNumber: set.setNumber,
                            weight: set.weight,
                            reps: set.reps,
                            isCompleted: set.isCompleted
                        )
                    }
                )
            }
        )
    }
}
