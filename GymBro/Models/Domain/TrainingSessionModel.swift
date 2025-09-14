//
//  GymBro
//
//  Created by macbook on 15/06/2025.
//

import SwiftUI
import CoreData

struct TrainingSessionModel: Identifiable {
    
    let id: UUID
    var calories: Int
    var countExercise: Int
    var dayOfWeek: String
    var durationMinutes: Int
    var foto: String
    var muscleName: String
    var isFinished: Bool = false
    var timestamp: Date?
    var exercises: [ExerciseModel]
    
    init(
        id: UUID = UUID(),
        calories: Int,
        countExercise: Int,
        dayOfWeek: String,
        durationMinutes: Int,
        foto: String,
        muscleName: String,
        isFinished: Bool,
        timestamp: Date? = nil,
        exercises: [ExerciseModel] = []
    ) {
        self.id = id
        self.calories = calories
        self.countExercise = countExercise
        self.dayOfWeek = dayOfWeek
        self.durationMinutes = durationMinutes
        self.foto = foto
        self.muscleName = muscleName
        self.isFinished = isFinished
        self.timestamp = timestamp
        self.exercises = exercises
    }
}


