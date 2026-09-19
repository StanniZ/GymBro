//
//  SubmitFinishedWatchWorkoutUseCase.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation

struct SubmitFinishedWatchWorkoutUseCase {
    private let repository: WatchWorkoutRepository

    init(repository: WatchWorkoutRepository) {
        self.repository = repository
    }

    func execute(session: WatchWorkoutSession, activeCalories: Double?) async throws {
        try await repository.submitFinishedWorkout(session, activeCalories: activeCalories)
    }
}
