//
//  StatisicsViewModel.swift
//  GymBro
//
//  Created by macbook on 10/09/2025.
//
import SwiftUI

@MainActor
final class HistorySessionViewModel: ObservableObject {
    @Published var sessions: [TrainingSessionModel] = []
    
    private let provider: StatisticsProtocol
    
    init(provider: StatisticsProtocol) {
        self.provider = provider
    }

    func load() async {
        do {
            sessions = try await provider.getAllFinishedSessions()
        } catch {
            sessions = []
            print("history load error:", error)
        }
    }
    
    // Last recorded sets for a given exercise (most recent session first)
    func lastSets(for exerciseID: Int) -> [ExerciseSetModel] {
        for session in sessions {
            if let exercise = session.exercises.first(where: { $0.exerciseID == exerciseID }) {
                return exercise.sets
            }
        }
        return []
    }

    func deleteSession(id: UUID) {
        if let idx = sessions.firstIndex(where: { $0.id == id }) {
            sessions.remove(at: idx)
        }
        
        Task {
            do {
                try await provider.deleteSession(with: id)
            } catch {
                await load()
                print("delete error:", error, "\n")
            }
        }
    }
}
