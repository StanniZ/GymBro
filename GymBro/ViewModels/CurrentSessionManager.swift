//
//  CurrentSessionProvider.swift
//  GymBro
//
//  Created by macbook on 20/07/2025.
//
import SwiftUI

final class CurrentSessionManager: CurrentSessionProviding, ObservableObject {

    private enum Storage {
        static let key = "gymbro_active_training_session_draft"
    }

    @Published private(set) var currentSession: TrainingSessionModel

    init() {
        currentSession = Self.restoreSession() ?? .empty
    }

    func setCurrentSession(_ session: TrainingSessionModel) {
        guard session != currentSession else { return }
        currentSession = session
        persist(session)
    }

    func clearCurrentSession() {
        currentSession = TrainingSessionModel.empty
        UserDefaults.standard.removeObject(forKey: Storage.key)
    }

    private func persist(_ session: TrainingSessionModel) {
        guard !session.exercises.isEmpty, !session.isFinished else {
            UserDefaults.standard.removeObject(forKey: Storage.key)
            return
        }

        guard let data = try? JSONEncoder().encode(session) else { return }
        UserDefaults.standard.set(data, forKey: Storage.key)
    }

    private static func restoreSession() -> TrainingSessionModel? {
        guard let data = UserDefaults.standard.data(forKey: Storage.key),
              let session = try? JSONDecoder().decode(TrainingSessionModel.self, from: data),
              !session.exercises.isEmpty,
              !session.isFinished
        else {
            return nil
        }

        return session
    }
}
