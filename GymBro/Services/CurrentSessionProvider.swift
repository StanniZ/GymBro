//
//  CurrentSessionProvider.swift
//  GymBro
//
//  Created by macbook on 20/07/2025.
//
import SwiftUI

final class CurrentSessionProvider: ObservableObject {
    @Published var currentSession: TrainingSessionModel?
    
    func setCurrentSession(_ session: TrainingSessionModel) {
        self.currentSession = session
    }
}
