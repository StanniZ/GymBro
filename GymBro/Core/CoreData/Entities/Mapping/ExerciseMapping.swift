//
//  ExerciseMapping.swift
//  GymBro
//
//  Created by macbook on 29/07/2025.
//
import Foundation
import CoreData

extension ExerciseEntity : Identifiable {
    
    var setsArray: [ExerciseSetEntity] {
        (sets as? Set<ExerciseSetEntity>)?.sorted(by: { $0.timestamp ?? .distantPast < $1.timestamp ?? .distantPast }) ?? []
    }
    
    func toModel() -> ExerciseModel {
        ExerciseModel(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            sets: setsArray.map { $0.toModel() }
        )
    }
    
    func update(from model: ExerciseModel) {
        self.id = model.id
        self.name = model.name
    }
}
