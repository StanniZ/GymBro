//
//  BuildSession.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI
import CoreData

struct WorkoutTemplate: Identifiable {
    var id: UUID
    var name: String
    var durationMinutes: Int
    var dayOfWeek: String
    var calories: Int
    var exercises: [TemplateExercise]
    var countExercise: Int {
        exercises.count
    }
    
    init(id: UUID = UUID(), name: String, durationMinutes: Int, dayOfWeek: String, calories: Int, exercises: [TemplateExercise]) {
        self.id = id
        self.name = name
        self.durationMinutes = durationMinutes
        self.dayOfWeek = dayOfWeek
        self.calories = calories
        self.exercises = exercises
    }
    
    static var empty: WorkoutTemplate {
        WorkoutTemplate(
            name: "New workout",
            durationMinutes: 0,
            dayOfWeek: "",
            calories: 0,
            exercises: []
        )
    }
}

extension BuildSessionModel {
    func toEntity(context: NSManagedObjectContext) -> TrainingSessionEntity {
        let entity = TrainingSessionEntity(context: context)
        entity.id = UUID()
        entity.muscleName = muscleName
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
