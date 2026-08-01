//
//  CurrentSessionProvider.swift
//  GymBro
//
//  Created by macbook on 20/07/2025.
//
import SwiftUI

final class CurrentSessionManager: CurrentSessionProviding, ObservableObject {
    
    @Published private(set) var currentSession: TrainingSessionModel = .empty
    
    func setCurrentSession(_ session: TrainingSessionModel) {
        currentSession = session
    }
    
    func clearCurrentSession() {
        currentSession = TrainingSessionModel.empty
    }
}
