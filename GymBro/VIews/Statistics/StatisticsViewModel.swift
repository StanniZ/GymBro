//
//  StatisicsViewModel.swift
//  GymBro
//
//  Created by macbook on 10/09/2025.
//
import SwiftUI

@MainActor
final class StatisticsViewModel: ObservableObject {
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
}
