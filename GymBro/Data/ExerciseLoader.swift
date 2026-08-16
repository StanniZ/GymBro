//
//  ExerciseLoader.swift
//  GymBro
//
//  Created by macbook on 25/07/2026.
//
import SwiftUI

enum ExerciseLoader {

    static let all: [ExerciseDefinition] = {
        guard let url  = Bundle.main.url(forResource: "Exercises", withExtension: "json") else {
            assertionFailure("exercise.json not found in bundle")
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([ExerciseDefinition].self, from: data)
        } catch {
            assertionFailure("Failed to decode exercises.json: \(error)")
            return []
        }
    }()
    
    static let byID: [Int: ExerciseDefinition] = Dictionary(
        uniqueKeysWithValues: all.map { ($0.id, $0) }
    )
    
    static let primaryID: [Int: MuscleGroup] = byID.mapValues {
        $0.primaryMuscle
    }
}
