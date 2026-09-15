//
//  DefaultWatchWorkoutRepository.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation

@MainActor
final class DefaultWatchWorkoutRepository: WatchWorkoutRepository {
    private let connectivityClient: WatchConnectivityClient

    init(connectivityClient: WatchConnectivityClient) {
        self.connectivityClient = connectivityClient
    }

    func fetchWorkoutTemplates() async throws -> [WatchWorkoutTemplate] {
        connectivityClient.requestTemplates()
        return connectivityClient.templates.isEmpty ? WatchWorkoutFixtures.templates : connectivityClient.templates
    }

    func submitFinishedWorkout(_ session: WatchWorkoutSession) async throws {
        try connectivityClient.submitFinishedWorkout(session)
    }
}
