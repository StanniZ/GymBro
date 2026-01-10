//
//  SessionTimerViewModel.swift
//  GymBro
//
//  Created by macbook on 17/11/2025.
//
import SwiftUI

final class SessionTimerViewModel: ObservableObject, SessionTimerProtocol {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var startDate: Date?
    private var timerTask: Task<Void, Never>?
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startDate = Date()
        
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(10))
                if let start = startDate {
                    elapsedTime = Date().timeIntervalSince(start)
                }
            }
        }
    }
    
    func finishSession() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
        startDate = nil
        elapsedTime = 0
    }
}
