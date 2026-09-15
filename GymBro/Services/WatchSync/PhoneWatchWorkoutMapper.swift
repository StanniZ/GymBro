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
            name: definition?.name ?? "Exercise \(exercise.exerciseID)",
            muscleGroup: muscleGroup,
            targetSets: max(exercise.setsCount, 1),
            defaultWeight: 0,
            defaultReps: max(exercise.reps, 1)
        )
    }
}
