//
//  SessionExerciseModel.swift
//  GymBro
//
//  Created by macbook on 18/07/2026.
//
import Foundation

struct SessionExerciseModel: Identifiable {
    var id: UUID
    var exerciseID: Int
    var position: Int
    var sets: [ExerciseSetModel]

    init(
        id: UUID = UUID(),
        exerciseID: Int,
        position: Int,
        sets: [ExerciseSetModel]
    ) {
        self.id = id
        self.exerciseID = exerciseID
        self.position = position
        self.sets = sets
    }
}
