//
//  DataGridBuildSession.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

final class DataGridBuildSession {
    
    static func getBuildSession() -> [BuildSessionModel] {
        return [
            BuildSessionModel(
                foto: "chestandtricepsfoto",
                muscleName: "Chest & Triceps",
                countExercise: 4,
                durationMinutes: 60,
                dayOfWeek: "Monday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Bench Press", sets: 4, reps: 8),
                    Exercise(name: "Dumbbell Press (45° Incline)", sets: 4, reps: 8),
                    Exercise(name: "Weighted Dips", sets: 4, reps: 8),
                    Exercise(name: "Cable Triceps Pushdown", sets: 4, reps: 8)
                ],
                calories: 450
            ),
            BuildSessionModel(
                foto: "backandbicepsfoto",
                muscleName: "Back & Biceps",
                countExercise: 4,
                durationMinutes: 65,
                dayOfWeek: "Tuesday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Barbell Bent-over Row", sets: 4, reps: 8),
                    Exercise(name: "Seated Cable Row", sets: 4, reps: 8),
                    Exercise(name: "EZ-Bar Bicep Curl", sets: 4, reps: 8),
                    Exercise(name: "Dumbbell Bicep Curl", sets: 4, reps: 8)
                ],
                calories: 500
            ),
            BuildSessionModel(
                foto: "shouldersfoto",
                muscleName: "Shoulders & Legs",
                countExercise: 4,
                durationMinutes: 70,
                dayOfWeek: "Wednesday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Standing Kettlebell Press", sets: 4, reps: 8),
                    Exercise(name: "Upright Row with Barbell", sets: 4, reps: 8),
                    Exercise(name: "Barbell Squat", sets: 4, reps: 8),
                    Exercise(name: "Leg Extension (Machine)", sets: 4, reps: 8)
                ],
                calories: 550
            ),
            
            // Вторник — силовая
            
            BuildSessionModel(
                foto: "strengthfoto",
                muscleName: "Full Body Strength",
                countExercise: 5,
                durationMinutes: 75,
                dayOfWeek: "Thursday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Deadlift", sets: 4, reps: 6),
                    Exercise(name: "Overhead Press", sets: 4, reps: 6),
                    Exercise(name: "Pull-Up", sets: 4, reps: 6),
                    Exercise(name: "Front Squat", sets: 4, reps: 6),
                    Exercise(name: "Barbell Row", sets: 4, reps: 6)
                ],
                calories: 600
            ),
            
            // Четверг — HIIT кардио
            BuildSessionModel(
                foto: "hiitfoto",
                muscleName: "HIIT Cardio",
                countExercise: 6,
                durationMinutes: 30,
                dayOfWeek: "Friday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Sprint Intervals", sets: 8, reps: 30),
                    Exercise(name: "Burpees", sets: 6, reps: 15),
                    Exercise(name: "Mountain Climbers", sets: 6, reps: 20),
                    Exercise(name: "Jump Squats", sets: 6, reps: 15),
                    Exercise(name: "High Knees", sets: 6, reps: 30),
                    Exercise(name: "Rest", sets: 6, reps: 30)
                ],
                calories: 400
            ),
            
            // Суббота — выносливое кардио
            BuildSessionModel(
                foto: "endurancecardiofoto",
                muscleName: "Endurance Cardio",
                countExercise: 1,
                durationMinutes: 45,
                dayOfWeek: "Saturday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Steady-State Run", sets: 1, reps: 45)
                ],
                calories: 500
            ),
            
            // Воскресенье — восстановительное кардио
            BuildSessionModel(
                foto: "recoverycardiofoto",
                muscleName: "Recovery Cardio",
                countExercise: 1,
                durationMinutes: 40,
                dayOfWeek: "Sunday",
                isFinished: false,
                exercises: [
                    Exercise(name: "Easy Bike Ride", sets: 1, reps: 40)
                ],
                calories: 300
            )
        ]
    }
}
