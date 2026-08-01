//
//  Exercise.swift
//  GymBro
//
//  Created by macbook on 17/07/2026.
//

import Foundation

struct ExerciseDefinition: Codable, Identifiable {
    
    let id: Int
    let name: String
    let primaryMuscle: MuscleGroup
    let secondaryMuscles: [MuscleGroup]
    let equipment: String
    let difficulty: String
    let description: String
    let video: String
}
