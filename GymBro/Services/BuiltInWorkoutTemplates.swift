//
//  DataGridBuildSession.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

final class BuiltInWorkoutTemplates {

    static func getBuildSession() -> [WorkoutTemplateModel] {
        [
            // MARK: - Chest & Triceps

            WorkoutTemplateModel(
                name: "Chest & Triceps",
                durationMinutes: 60,
                dayOfWeek: "Monday",
                calories: 300,
                exercises: [
                    // ID 1 — Barbell Bench Press
                    TemplateExercise(
                        exerciseID: 1,
                        setsCount: 1,
                        reps: 0
                    ),

                    // ID 5 — Incline Dumbbell Press
                    TemplateExercise(
                        exerciseID: 5,
                        setsCount: 1,
                        reps: 0
                    ),

                    // ID 10 — Weighted Dips
                    TemplateExercise(
                        exerciseID: 10,
                        setsCount: 1,
                        reps: 0
                    ),

                    // ID 27 — Cable Triceps Pushdown
                    TemplateExercise(
                        exerciseID: 27,
                        setsCount: 1,
                        reps: 0
                    ),

                    // ID 30 — Close-Grip Bench Press
                    TemplateExercise(
                        exerciseID: 30,
                        setsCount: 1,
                        reps: 0
                    )
                ]
            ),

            // MARK: - Back & Biceps

            WorkoutTemplateModel(
                name: "Back & Biceps",
                durationMinutes: 65,
                dayOfWeek: "Tuesday",
                calories: 500,
                exercises: [
                    TemplateExercise(
                        exerciseID: 36,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 42,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 46,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 21,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 23,
                        setsCount: 1,
                        reps: 0
                    )
                ]
            ),

            // MARK: - Legs & Glutes

            WorkoutTemplateModel(
                name: "Legs & Glutes",
                durationMinutes: 70,
                dayOfWeek: "Wednesday",
                calories: 550,
                exercises: [
                    TemplateExercise(
                        exerciseID: 66,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 70,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 79,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 83,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 91,
                        setsCount: 1,
                        reps: 0
                    )
                ]
            ),

            // MARK: - Shoulders & Core

            WorkoutTemplateModel(
                name: "Shoulders & Core",
                durationMinutes: 55,
                dayOfWeek: "Thursday",
                calories: 400,
                exercises: [
                    TemplateExercise(
                        exerciseID: 11,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 16,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 100,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 104,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 109,
                        setsCount: 1,
                        reps: 0
                    )
                ]
            ),

            // MARK: - Full Body Strength

            WorkoutTemplateModel(
                name: "Full Body Strength",
                durationMinutes: 75,
                dayOfWeek: "Friday",
                calories: 600,
                exercises: [
                    TemplateExercise(
                        exerciseID: 56,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 67,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 1,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 36,
                        setsCount: 1,
                        reps: 0
                    ),
                    TemplateExercise(
                        exerciseID: 118,
                        setsCount: 1,
                        reps: 0
                    )
                ]
            )
        ]
    }
}
