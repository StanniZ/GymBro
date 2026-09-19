//
//  WorkoutSetModel.swift
//  GymBro
//
//  Created by macbook on 18/07/2026.
//
import Foundation

struct ExerciseSetModel: Identifiable, Codable, Equatable {
    var id: UUID
    var reps: Int
    var weightKg: Double
    var isCompleted: Bool
    var timestamp: Date?
    var position: Int

    init(
        id: UUID = UUID(),
        reps: Int = 0,
        weightKg: Double = 0,
        isCompleted: Bool = false,
        timestamp: Date? = nil,
        position: Int
    ) {
        self.id = id
        self.reps = reps
        self.weightKg = weightKg
        self.isCompleted = isCompleted
        self.timestamp = timestamp
        self.position = position
    }
}
