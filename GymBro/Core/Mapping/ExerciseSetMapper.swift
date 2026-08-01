//
//  WorkoutSetMapper.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import CoreData

enum WorkoutSetMapper {
    
    static func toEntity(_ model: WorkoutSetModel, context: NSManagedObjectContext) -> WorkoutSetEntity {
        let entity = WorkoutSetEntity(context: context)
        
    }
}
