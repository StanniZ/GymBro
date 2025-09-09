//
//  TrainingSessionViewModel.swift
//  GymBro
//
//  Created by macbook on 20/06/2025.
//
import SwiftUI

final class BuildSessionViewModel: ObservableObject {
    @Published var sessions: [TrainingSessionModel] = []
    private let currentSessionProvider: CurrentSessionProvider
    
    private let provider: BuildSessionProviderProtocol
    
    init(provider: BuildSessionProviderProtocol,
         currentSessionProvider: CurrentSessionProvider) {
        self.provider = provider
        self.currentSessionProvider = currentSessionProvider
        loadSessions()
    }
    
    func loadSessions() {
        sessions = provider.fetchSessions()
    }
    
    func didSelectSession(_ session: TrainingSessionModel) {
        currentSessionProvider.setCurrentSession(session)
    }
    
    
}
