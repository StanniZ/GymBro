//
//  ExerciseModel.swift
//  GymBro
//
//  Created by macbook on 03/06/2025.
//
import SwiftUI

struct ExerciseSetModel: Identifiable, Equatable{
    var id = UUID()
    var reps: Int
    var timestamp: Date
    var weightKg: Double
    
    
    init(id: UUID = UUID(), reps: Int, timestamp: Date, weightKg: Double) {
        self.id = id
        self.reps = reps
        self.timestamp = timestamp
        self.weightKg = weightKg
    }
}
