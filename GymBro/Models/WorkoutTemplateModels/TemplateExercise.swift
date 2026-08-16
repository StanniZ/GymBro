//
//  TemplateExercise.swift
//  GymBro
//
//  Created by macbook on 18/07/2026.
//
import Foundation

struct TemplateExercise: Identifiable {
    var id: UUID
    var exerciseID: Int
    var setsCount: Int
    var reps: Int
//    var position: Int
    
    init(id: UUID = UUID(), exerciseID: Int, setsCount: Int, reps: Int) {
        self.id = id
        self.exerciseID = exerciseID
        self.setsCount = setsCount
        self.reps = reps
//        self.position = position
    }
}
