//
//  WorkoutTemplateMapper.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import CoreData

enum WorkoutTemplateMapper {

    static func toEntity(_ model: WorkoutTemplateModel, context: NSManagedObjectContext) -> WorkoutTemplateEntity {
        let entity = WorkoutTemplateEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.durationMinutes = Int16(model.durationMinutes)
        entity.dayOfWeek = model.dayOfWeek
        entity.calories = Int16(model.calories)
        entity.createdAt = Date()
        entity.exercises = NSSet(array: model.exercises.map {
            TemplateExerciseMapper.toEntity($0, context: context)
        })
        return entity
    }

    static func toModel(_ entity: WorkoutTemplateEntity) -> WorkoutTemplateModel {
        let exercises = (entity.exercises as? Set<TemplateExerciseEntity>)?
            .map(TemplateExerciseMapper.toModel)
            ?? []

        return WorkoutTemplateModel(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            durationMinutes: Int(entity.durationMinutes),
            dayOfWeek: entity.dayOfWeek ?? "",
            calories: Int(entity.calories),
            exercises: exercises
        )
    }
}
