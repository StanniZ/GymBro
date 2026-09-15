//
//  LoadWatchWorkoutTemplatesUseCase.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation

struct LoadWatchWorkoutTemplatesUseCase {
    private let repository: WatchWorkoutRepository

    init(repository: WatchWorkoutRepository) {
        self.repository = repository
    }

    func execute() async throws -> [WatchWorkoutTemplate] {
        try await repository.fetchWorkoutTemplates()
    }
}
