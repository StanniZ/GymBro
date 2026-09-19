//
//  WatchWorkoutRepository.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation

protocol WatchWorkoutRepository {
    func fetchWorkoutTemplates() async throws -> [WatchWorkoutTemplate]
    func submitFinishedWorkout(_ session: WatchWorkoutSession, activeCalories: Double?) async throws
}
