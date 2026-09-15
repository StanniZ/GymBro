//
//  WatchWorkoutFixtures.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation

enum WatchWorkoutFixtures {
    static let templates: [WatchWorkoutTemplate] = [
        WatchWorkoutTemplate(
            title: "Push Day",
            subtitle: "Chest / Shoulders / Triceps",
            estimatedMinutes: 45,
            exercises: [
                WatchExercisePlan(name: "Bench Press", muscleGroup: "Chest", targetSets: 4, defaultWeight: 60, defaultReps: 8),
                WatchExercisePlan(name: "Incline DB Press", muscleGroup: "Chest", targetSets: 3, defaultWeight: 24, defaultReps: 10),
                WatchExercisePlan(name: "Shoulder Press", muscleGroup: "Shoulders", targetSets: 3, defaultWeight: 35, defaultReps: 8),
                WatchExercisePlan(name: "Triceps Pushdown", muscleGroup: "Triceps", targetSets: 3, defaultWeight: 25, defaultReps: 12)
            ]
        ),
        WatchWorkoutTemplate(
            title: "Pull Day",
            subtitle: "Back / Biceps",
            estimatedMinutes: 40,
            exercises: [
                WatchExercisePlan(name: "Pull Up", muscleGroup: "Back", targetSets: 4, defaultWeight: 0, defaultReps: 8),
                WatchExercisePlan(name: "Barbell Row", muscleGroup: "Back", targetSets: 4, defaultWeight: 50, defaultReps: 8),
                WatchExercisePlan(name: "Lat Pulldown", muscleGroup: "Back", targetSets: 3, defaultWeight: 45, defaultReps: 10),
                WatchExercisePlan(name: "Biceps Curl", muscleGroup: "Biceps", targetSets: 3, defaultWeight: 12, defaultReps: 12)
            ]
        ),
        WatchWorkoutTemplate(
            title: "Leg Day",
            subtitle: "Quads / Hamstrings / Glutes",
            estimatedMinutes: 50,
            exercises: [
                WatchExercisePlan(name: "Squat", muscleGroup: "Legs", targetSets: 4, defaultWeight: 80, defaultReps: 6),
                WatchExercisePlan(name: "Romanian Deadlift", muscleGroup: "Hamstrings", targetSets: 3, defaultWeight: 70, defaultReps: 8),
                WatchExercisePlan(name: "Leg Press", muscleGroup: "Quads", targetSets: 3, defaultWeight: 120, defaultReps: 10),
                WatchExercisePlan(name: "Calf Raise", muscleGroup: "Calves", targetSets: 4, defaultWeight: 40, defaultReps: 15)
            ]
        )
    ]
}
