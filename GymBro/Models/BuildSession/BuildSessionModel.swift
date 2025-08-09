//
//  BuildSession.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI
import CoreData

struct BuildSessionModel: Identifiable {
    let id = UUID()
    let foto: String
    let muscleName: String
    let countExercise: Int
    let durationMinutes: Int16
    let dayOfWeek: String
    let isFinished: Bool
    var exercises: [Exercise]
    let calories: Int16
    
    static func empty() -> BuildSessionModel {
        return .init(
            foto: "",
            muscleName: "",
            countExercise: 0,
            durationMinutes: 0,
            dayOfWeek: "",
            isFinished: false,
            exercises: [],
            calories: 0
        )
    }
}

extension BuildSessionModel {
    func toEntity(context: NSManagedObjectContext) -> TrainingSessionEntity {
        let entity = TrainingSessionEntity(context: context)
        entity.id = UUID()
        entity.muscleName = muscleName
        entity.foto = foto
        entity.durationMinutes = Int16(durationMinutes)
        entity.dayOfWeek = dayOfWeek
        entity.isFinished = isFinished
        
        entity.calories = Int16(calories)
        
        exercises.forEach { ex in
            let exercise = ExerciseEntity(context: context)
            exercise.id = UUID()
            exercise.name = ex.name
            exercise.session = entity
            
            for _ in 0..<ex.sets {
                let set = ExerciseSetEntity(context: context)
                set.id = UUID()
                set.reps = Int16(ex.reps)
                set.weightKg = 0.0
                set.timestamp = Date()
                set.exercise = exercise
            }
        }
        
        return entity
    }
}
