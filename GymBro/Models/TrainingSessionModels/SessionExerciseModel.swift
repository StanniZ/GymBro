//
//  SessionExercise.swift
//  GymBro
//
//  Created by macbook on 18/07/2026.
//
import Foundation

struct SessionExercise: Identifiable {
    var id: UUID
    var exerciseID: Int
    var sets: [WorkoutSet]

    init(
        id: UUID = UUID(),
        exerciseID: Int,
        sets: [WorkoutSet]
    ) {
        self.id = id
        self.exerciseID = exerciseID
        self.sets = sets
    }
}
