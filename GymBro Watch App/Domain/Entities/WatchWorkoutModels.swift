//
//  WatchWorkoutModels.swift
//  GymBro Watch App
//
//  Created by Codex on 14/09/2026.
//

import Foundation

struct WatchWorkoutTemplate: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let estimatedMinutes: Int
    let exercises: [WatchExercisePlan]

    nonisolated init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        estimatedMinutes: Int,
        exercises: [WatchExercisePlan]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.estimatedMinutes = estimatedMinutes
        self.exercises = exercises
    }
}

struct WatchExercisePlan: Identifiable, Hashable {
    let id: UUID
    let name: String
    let muscleGroup: String
    let targetSets: Int
    let defaultWeight: Double
    let defaultReps: Int

    nonisolated init(
        id: UUID = UUID(),
        name: String,
        muscleGroup: String,
        targetSets: Int,
        defaultWeight: Double,
        defaultReps: Int
    ) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.targetSets = targetSets
        self.defaultWeight = defaultWeight
        self.defaultReps = defaultReps
    }
}

struct WatchWorkoutSession: Identifiable, Hashable {
    let id: UUID
    let title: String
    let startedAt: Date
    var exercises: [WatchSessionExercise]
    var currentExerciseIndex: Int
    var isPaused: Bool
    var pausedAt: Date?
    var pausedDuration: TimeInterval

    nonisolated init(template: WatchWorkoutTemplate, startedAt: Date = Date()) {
        self.id = UUID()
        self.title = template.title
        self.startedAt = startedAt
        self.exercises = template.exercises.map { WatchSessionExercise(plan: $0) }
        self.currentExerciseIndex = 0
        self.isPaused = false
        self.pausedAt = nil
        self.pausedDuration = 0
    }
}

struct WatchSessionExercise: Identifiable, Hashable {
    let id: UUID
    let name: String
    let muscleGroup: String
    var isFinished: Bool
    var sets: [WatchExerciseSet]

    nonisolated init(plan: WatchExercisePlan) {
        self.id = plan.id
        self.name = plan.name
        self.muscleGroup = plan.muscleGroup
        self.isFinished = false
        self.sets = (1...max(plan.targetSets, 1)).map { index in
            WatchExerciseSet(
                setNumber: index,
                weight: plan.defaultWeight,
                reps: plan.defaultReps,
                isCompleted: false
            )
        }
    }
}

struct WatchExerciseSet: Identifiable, Hashable {
    let id: UUID
    var setNumber: Int
    var weight: Double
    var reps: Int
    var isCompleted: Bool

    nonisolated init(id: UUID = UUID(), setNumber: Int, weight: Double, reps: Int, isCompleted: Bool) {
        self.id = id
        self.setNumber = setNumber
        self.weight = weight
        self.reps = reps
        self.isCompleted = isCompleted
    }
}
