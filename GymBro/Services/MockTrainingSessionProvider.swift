//
//  MockTrainingSessionProvider.swift
//  GymBro
//
//  Created by macbook on 20/06/2025.
//
import SwiftUI

class MockTrainingSessionProvider: BuildSessionProviderProtocol {
    func fetchSessions() -> [TrainingSessionModel] {
        [
            TrainingSessionModel(
                id: UUID(),
                calories: 300,
                countExercise: 3,
                dayOfWeek: "Monday",
                durationMinutes: 45,
                foto: "sample_foto",
                muscleName: "Back",
                isFinished: false,
                exercises: []
            )
        ]
    }
}
