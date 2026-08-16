//
//  TrainingSessionMapper.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import CoreData

enum TrainingSessionMapper {
    
    static func toEntity(_ model: TrainingSessionModel, context: NSManagedObjectContext) -> TrainingSessionEntity {
        
        let entity = TrainingSessionEntity(context: context)
        
        entity.id = model.id
        entity.name = model.name
        entity.durationMinutes = Int16(model.durationMinutes)
        entity.dayOfWeek = model.dayOfWeek
        entity.calories = Int16(model.calories)
        entity.startedAt = model.startedAt
        entity.finishedAt = model.finishedAt
        entity.isFinished = model.isFinished
        entity.exercises = NSSet(array: model.exercises.map {
            SessionExerciseMapper.toEntity($0, context: context)
        })
        
        return entity
    }
    
    static func toModel(_ entity: TrainingSessionEntity) -> TrainingSessionModel {
        
        let exercises = (entity.exercises as? Set<SessionExerciseEntity>)?
            .map(SessionExerciseMapper.toModel) ?? []
        
        return TrainingSessionModel(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            durationMinutes: Int(entity.durationMinutes),
            dayOfWeek: entity.dayOfWeek ?? "",
            calories: Int(entity.calories),
            startedAt: entity.startedAt ?? Date(),
            finishedAt: entity.finishedAt,
            isFinished: entity.isFinished,
            exercises: exercises
            )
    }
}
