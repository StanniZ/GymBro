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
    @Published var isPaused: Bool = false

    private var startDate: Date?
    private var timerTask: Task<Void, Never>?

    var formattedTime: String {
        let seconds = Int(elapsedTime)
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        if h > 0 {
            return String(format: "%02d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        isPaused = false
        startDate = Date().addingTimeInterval(-elapsedTime)

        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                let now = Date()
                await MainActor.run { [weak self] in
                    guard let self, let start = self.startDate else { return }
                    self.elapsedTime = now.timeIntervalSince(start)
                }
            }
        }
    }

    func pause() {
        guard isRunning else { return }
        isRunning = false
        isPaused = true
        timerTask?.cancel()
        timerTask = nil
        startDate = nil
    }

    func finishSession() {
        isRunning = false
        isPaused = false
        timerTask?.cancel()
        timerTask = nil
        startDate = nil
        elapsedTime = 0
    }
}
