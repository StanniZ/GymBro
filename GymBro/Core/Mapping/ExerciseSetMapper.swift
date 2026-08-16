//
//  WorkoutSetMapper.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import CoreData

enum ExerciseSetMapper {
    
    static func toEntity(_ model: ExerciseSetModel, context: NSManagedObjectContext) -> ExerciseSetEntity {
        
        let entity = ExerciseSetEntity(context: context)
        
        entity.id = model.id
        entity.reps = Int16(model.reps)
        entity.weightKg = model.weightKg
        entity.isCompleted = model.isCompleted
        entity.timestamp = model.timestamp
        entity.position = Int16(model.position)
        
        return entity
    }
    
    static func toModel(_ entity: ExerciseSetEntity) -> ExerciseSetModel {
        
        ExerciseSetModel(
            id: entity.id ?? UUID(),
            reps: Int(entity.reps),
            weightKg: entity.weightKg,
            isCompleted: entity.isCompleted,
            timestamp: entity.timestamp,
            position: Int(entity.position)
        )
    }
}
