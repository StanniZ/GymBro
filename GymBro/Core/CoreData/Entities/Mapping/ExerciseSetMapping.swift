//
//  ExerciseSetMapping.swift
//  GymBro
//
//  Created by macbook on 29/07/2025.
//

import Foundation
import CoreData

extension ExerciseSetEntity : Identifiable {
    
    func toModel() -> ExerciseSetModel {
        ExerciseSetModel(
            id: self.id ?? UUID(),
            reps: Int(self.reps),
            timestamp: self.timestamp!,
            weightKg: Double(self.weightKg)
        )
    }
    
    func update(from model: ExerciseSetModel){
        self.id = model.id
        self.reps = Int16(model.reps)
        self.timestamp = model.timestamp
        self.weightKg = Double(model.weightKg)
    }
}
