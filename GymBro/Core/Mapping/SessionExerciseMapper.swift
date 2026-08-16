//
//  SessionExerciseMapper.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import CoreData

enum SessionExerciseMapper {
    
    static func toEntity(_ model: SessionExerciseModel, context: NSManagedObjectContext) -> SessionExerciseEntity {
        
        let entity = SessionExerciseEntity(context: context)
        entity.id = model.id
        entity.exerciseID = Int64(model.exerciseID)
        entity.position = Int16(model.position)
        entity.sets = NSSet(array: model.sets.map {
            ExerciseSetMapper.toEntity($0, context: context)
        })
        
        return entity
    }
    
    static func toModel(_ entity: SessionExerciseEntity) -> SessionExerciseModel {
        
        let sets = (entity.sets as? Set<ExerciseSetEntity>)?
            .map(ExerciseSetMapper.toModel)
        ?? []
        
        return SessionExerciseModel(
            id: entity.id ?? UUID(),
            exerciseID: Int(entity.exerciseID),
            position: Int(entity.position),
            sets: sets
        )
    }
}
