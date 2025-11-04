//
//  TrainingSessionMapping.swift
//  GymBro
//
//  Created by macbook on 29/07/2025.
//

import Foundation
import CoreData

extension TrainingSessionEntity : Identifiable {
    
    var exercisesArray: [ExerciseEntity] {
        (exercises as? Set<ExerciseEntity>)?.sorted(by: { $0.name ?? "" < $1.name ?? "" }) ?? []
    }
    
    func toModel() -> TrainingSessionModel {
        TrainingSessionModel(
            id: self.id ?? UUID(),
            calories: Int(self.calories),
            countExercise: exercisesCount,
            dayOfWeek: self.dayOfWeek ?? "",
            durationMinutes: Int(self.durationMinutes),
            foto: self.foto ?? "",
            muscleName: self.muscleName ?? "",
            isFinished: self.isFinished,
            timestamp: self.timestamp ?? Date(),
            exercises: exercisesArray.map { $0.toModel() }
        )
    }

    func update(from model: TrainingSessionModel, context: NSManagedObjectContext) {
        self.id = model.id
        self.calories = Int16(model.calories)
        self.dayOfWeek = model.dayOfWeek
        self.durationMinutes = Int16(model.durationMinutes)
        self.foto = model.foto
        self.muscleName = model.muscleName
        self.isFinished = model.isFinished
        self.timestamp = model.timestamp

        let exerciseEntities = model.exercises.map { model in
            let entity = ExerciseEntity(context: context)
            entity.update(from: model)
            return entity
        }
        self.exercises = NSSet(array: exerciseEntities)
    }

    var exercisesCount: Int {
        exercisesArray.count
    }
}



extension TrainingSessionModel {
    static var empty: TrainingSessionModel {
        TrainingSessionModel(
            id: UUID(),
            calories: 0,
            countExercise: 0,
            dayOfWeek: "",
            durationMinutes: 0,
            foto: "",
            muscleName: "",
            isFinished: false,
            timestamp: Date(),
            exercises: []
        )
    }
    
    func toEntity(context: NSManagedObjectContext) -> TrainingSessionEntity {
        let entity = TrainingSessionEntity(context: context)
        entity.id = id
        entity.muscleName = muscleName
        entity.foto = foto
        entity.durationMinutes = Int16(durationMinutes)
        entity.dayOfWeek = dayOfWeek
        entity.calories = Int16(calories)
        entity.isFinished = isFinished
        entity.timestamp = timestamp
        
        let exerciseEntities = exercises.map { ex in
            let exercise = ExerciseEntity(context: context)
            exercise.id = ex.id
            exercise.name = ex.name
            exercise.session = entity
            
            let setEntities = ex.sets.map { setModel -> ExerciseSetEntity in
                let setEntity = ExerciseSetEntity(context: context)
                setEntity.id = setModel.id
                setEntity.reps = Int16(setModel.reps)
                setEntity.timestamp = setModel.timestamp
                setEntity.weightKg = setModel.weightKg
                setEntity.exercise = exercise
                return setEntity
            }
            exercise.sets = NSSet(array: setEntities)
            return exercise
        }
        entity.exercises = NSSet(array: exerciseEntities)
        return entity
    }
}
