//
//  PhoneWatchWorkoutMapper.swift
//  GymBro
//
//  Created by Codex on 15/09/2026.
//

import Foundation

enum PhoneWatchWorkoutMapper {
    static func makeSnapshot(from templates: [WorkoutTemplateModel]) -> PhoneWatchTemplatesSnapshotPayload {
        PhoneWatchTemplatesSnapshotPayload(
            templates: templates.map(makeTemplatePayload),
            generatedAt: Date()
        )
    }

    private static func makeTemplatePayload(from template: WorkoutTemplateModel) -> PhoneWatchWorkoutTemplatePayload {
        PhoneWatchWorkoutTemplatePayload(
            id: template.id,
            title: template.name,
            subtitle: template.dayOfWeek.isEmpty ? "\(template.countExercise) exercises" : template.dayOfWeek,
            estimatedMinutes: template.durationMinutes,
            exercises: template.exercises.map(makeExercisePayload)
        )
    }

    private static func makeExercisePayload(from exercise: TemplateExercise) -> PhoneWatchExercisePlanPayload {
        let definition = ExerciseLoader.byID[exercise.exerciseID]
        let muscleGroup = ExerciseLoader.primaryID[exercise.exerciseID]?.rawValue.replacingOccurrences(of: "_", with: " ").capitalized ?? "Workout"

        return PhoneWatchExercisePlanPayload(
            id: exercise.id,
            exerciseID: exercise.exerciseID,
            name: definition?.name ?? "Exercise \(exercise.exerciseID)",
            muscleGroup: muscleGroup,
            targetSets: max(exercise.setsCount, 1),
            defaultWeight: 0,
            defaultReps: max(exercise.reps, 1)
        )
    }

    static func makeTrainingSession(from payload: PhoneWatchFinishedWorkoutPayload) -> TrainingSessionModel {
        let duration = max(Int(payload.finishedAt.timeIntervalSince(payload.startedAt) / 60), 0)

        return TrainingSessionModel(
            id: payload.id,
            name: payload.title,
            durationMinutes: duration,
            dayOfWeek: "",
            calories: payload.activeCalories ?? 0,
            startedAt: payload.startedAt,
            finishedAt: payload.finishedAt,
            isFinished: true,
            exercises: payload.exercises.enumerated().map { exerciseIndex, exercise in
                SessionExerciseModel(
                    id: exercise.id,
                    exerciseID: exercise.exerciseID,
                    position: exerciseIndex,
                    sets: exercise.sets.enumerated().map { setIndex, set in
                        ExerciseSetModel(
                            id: set.id,
                            reps: set.reps,
                            weightKg: set.weight,
                            isCompleted: set.isCompleted,
                            timestamp: set.isCompleted ? payload.finishedAt : nil,
                            position: setIndex
                        )
                    }
                )
            }
        )
    }
}
