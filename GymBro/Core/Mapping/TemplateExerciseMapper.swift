//
//  TemplateExerciseMapper.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import CoreData

enum TemplateExerciseMapper {
    
    static func toEntity(_ model: TemplateExercise, context: NSManagedObjectContext) -> TemplateExerciseEntity {
        
        let entity = TemplateExerciseEntity(context: context)
        
        entity.id = model.id
        entity.exerciseID = Int64(model.exerciseID)
        entity.setsCount = Int16(model.setsCount)
        entity.reps = Int16(model.reps)
        
        return entity
    }
    
    static func toModel(_ entity: TemplateExerciseEntity) -> TemplateExercise {
        
        TemplateExercise(
            id: entity.id ?? UUID(),
            exerciseID:  Int(entity.exerciseID),
            setsCount: Int(entity.setsCount),
            reps: Int(entity.reps),
        )
    }
}
