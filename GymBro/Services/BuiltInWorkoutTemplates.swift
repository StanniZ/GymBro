//
//  DataGridBuildSession.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

final class DataGridBuildSession {

    static func getBuildSession() -> [BuildSessionModel] {
        [
            // MARK: - Chest & Triceps

            BuildSessionModel(
                muscleName: "Chest & Triceps",
                durationMinutes: 60,
                dayOfWeek: "Monday",
                isFinished: false,
                exercises: [
                    // ID 1 — Barbell Bench Press
                    WorkoutExercise(
                        exerciseID: 1,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 5 — Incline Dumbbell Press
                    WorkoutExercise(
                        exerciseID: 5,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 10 — Weighted Dips
                    WorkoutExercise(
                        exerciseID: 10,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 27 — Cable Triceps Pushdown
                    WorkoutExercise(
                        exerciseID: 27,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 30 — Close-Grip Bench Press
                    WorkoutExercise(
                        exerciseID: 30,
                        sets: 1,
                        reps: 0
                    )
                ],
                calories: 450
            ),

            // MARK: - Back & Biceps

            BuildSessionModel(
                muscleName: "Back & Biceps",
                durationMinutes: 65,
                dayOfWeek: "Tuesday",
                isFinished: false,
                exercises: [
                    // ID 36 — Pull-Up
                    WorkoutExercise(
                        exerciseID: 36,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 42 — Seated Cable Row
                    WorkoutExercise(
                        exerciseID: 42,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 46 — Bent Over Barbell Row
                    WorkoutExercise(
                        exerciseID: 46,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 21 — EZ Bar Curl
                    WorkoutExercise(
                        exerciseID: 21,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 23 — Hammer Curl
                    WorkoutExercise(
                        exerciseID: 23,
                        sets: 1,
                        reps: 0
                    )
                ],
                calories: 500
            ),

            // MARK: - Legs & Glutes

            BuildSessionModel(
                muscleName: "Legs & Glutes",
                durationMinutes: 70,
                dayOfWeek: "Wednesday",
                isFinished: false,
                exercises: [
                    // ID 66 — Back Squat
                    WorkoutExercise(
                        exerciseID: 66,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 70 — Bulgarian Split Squat
                    WorkoutExercise(
                        exerciseID: 70,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 79 — Lying Leg Curl
                    WorkoutExercise(
                        exerciseID: 79,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 83 — Hip Thrust
                    WorkoutExercise(
                        exerciseID: 83,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 91 — Standing Calf Raise
                    WorkoutExercise(
                        exerciseID: 91,
                        sets: 1,
                        reps: 0
                    )
                ],
                calories: 550
            ),

            // MARK: - Shoulders & Core

            BuildSessionModel(
                muscleName: "Shoulders & Core",
                durationMinutes: 55,
                dayOfWeek: "Thursday",
                isFinished: false,
                exercises: [
                    // ID 11 — Barbell Overhead Press
                    WorkoutExercise(
                        exerciseID: 11,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 16 — Face Pull
                    WorkoutExercise(
                        exerciseID: 16,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 100 — Ab Wheel Rollout
                    WorkoutExercise(
                        exerciseID: 100,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 104 — Hanging Leg Raise
                    WorkoutExercise(
                        exerciseID: 104,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 109 — Cable Wood Chop
                    WorkoutExercise(
                        exerciseID: 109,
                        sets: 1,
                        reps: 0
                    )
                ],
                calories: 400
            ),

            // MARK: - Full Body Strength

            BuildSessionModel(
                muscleName: "Full Body Strength",
                durationMinutes: 75,
                dayOfWeek: "Friday",
                isFinished: false,
                exercises: [
                    // ID 56 — Conventional Deadlift
                    WorkoutExercise(
                        exerciseID: 56,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 67 — Front Squat
                    WorkoutExercise(
                        exerciseID: 67,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 1 — Barbell Bench Press
                    WorkoutExercise(
                        exerciseID: 1,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 36 — Pull-Up
                    WorkoutExercise(
                        exerciseID: 36,
                        sets: 1,
                        reps: 0
                    ),

                    // ID 118 — Kettlebell Swing
                    WorkoutExercise(
                        exerciseID: 118,
                        sets: 1,
                        reps: 0
                    )
                ],
                calories: 600
            )
        ]
    }
}
