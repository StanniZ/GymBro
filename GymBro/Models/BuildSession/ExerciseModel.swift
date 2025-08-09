//
//  ExerciseSet.swift
//  GymBro
//
//  Created by macbook on 11/06/2025.
//
import SwiftUI

struct ExerciseModel: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var sets: [ExerciseSetModel]
    var isExpanded: Bool = false
    
    init(id: UUID = UUID(), name: String, sets: [ExerciseSetModel] = []) {
        self.id = id
        self.name = name
        self.sets = sets
    }
}
