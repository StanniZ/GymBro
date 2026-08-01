//
//  TrainingSessionModel.swift
//  GymBro
//
//  Created by macbook on 18/07/2026.
//
import Foundation

struct TrainingSessionModel: Identifiable {
    var id: UUID
    var name: String
    var durationMinutes: Int
    var dayOfWeek: String
    var calories: Int

    var startedAt: Date
    var finishedAt: Date?
    var isFinished: Bool

    var exercises: [SessionExerciseModel]

    var countExercise: Int {
        exercises.count
    }

    init(
        id: UUID = UUID(),
        name: String,
        durationMinutes: Int,
        dayOfWeek: String,
        calories: Int,
        startedAt: Date = Date(),
        finishedAt: Date? = nil,
        isFinished: Bool = false,
        exercises: [SessionExerciseModel]
    ) {
        self.id = id
        self.name = name
        self.durationMinutes = durationMinutes
        self.dayOfWeek = dayOfWeek
        self.calories = calories
        self.startedAt = startedAt
        self.finishedAt = finishedAt
        self.isFinished = isFinished
        self.exercises = exercises
    }
}

extension TrainingSessionModel {
    static var empty: TrainingSessionModel {
        WorkoutTemplateModel.empty.makeTrainingSession()
    }

    func asTemplate() -> WorkoutTemplateModel {
        WorkoutTemplateModel(
            id: id,
            name: name,
            durationMinutes: durationMinutes,
            dayOfWeek: dayOfWeek,
            calories: calories,
            exercises: exercises.map { exercise in
                TemplateExercise(
                    exerciseID: exercise.exerciseID,
                    setsCount: max(exercise.sets.count, 1),
                    reps: exercise.sets.first?.reps ?? 0
                )
            }
        )
    }
}
