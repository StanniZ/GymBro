//
//  TodaySessionViewModel.swift
//  GymBro
//
//  Created by macbook on 21/06/2025.
//
import SwiftUI
import Combine

@MainActor
final class TodaySessionViewModel: ObservableObject {

    enum SaveState: Equatable { case ready, saving, saved, failed(String) }

    @Published var state: SaveState = .ready
    @Published var draftSession: TrainingSessionModel

    private let provider: WorkoutSessionProviderProtocol
    private let templateRepository: WorkoutTemplateRepositoryProtocol
    private let currentSessionProvider: CurrentSessionManager
    private var currentSessionCancellable: AnyCancellable?
    private var draftSessionCancellable: AnyCancellable?
    private var isApplyingCurrentSession = false

    init(provider: WorkoutSessionProviderProtocol,
         currentSessionProvider: CurrentSessionManager,
         templateRepository: WorkoutTemplateRepositoryProtocol) {
        self.provider = provider
        self.templateRepository = templateRepository
        self.currentSessionProvider = currentSessionProvider
        self.draftSession = currentSessionProvider.currentSession

        currentSessionCancellable = currentSessionProvider.$currentSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let self else { return }
                self.isApplyingCurrentSession = true
                self.draftSession = session
                self.state = .ready
                self.isApplyingCurrentSession = false
            }

        draftSessionCancellable = $draftSession
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] session in
                guard let self, !self.isApplyingCurrentSession else { return }
                self.currentSessionProvider.setCurrentSession(session)
            }
    }

    func startSession() {
        draftSession.startedAt = Date()
        currentSessionProvider.setCurrentSession(draftSession)
    }

    // Add exercises from picker during live workout
    func addExercises(_ definitions: [ExerciseDefinition]) {
        let newExercises = definitions.map { def in
            SessionExerciseModel(
                exerciseID: def.id,
                position: draftSession.exercises.count,
                sets: [ExerciseSetModel(reps: 0, weightKg: 0, position: 0)]
            )
        }
        draftSession.exercises.append(contentsOf: newExercises)
        currentSessionProvider.setCurrentSession(draftSession)
    }

    func removeExercise(id: UUID) {
        draftSession.exercises.removeAll { $0.id == id }
        currentSessionProvider.setCurrentSession(draftSession)
    }

    func finishSession(elapsedSeconds: TimeInterval = 0) {
        guard state == .ready else { return }
        let endDate = Date()
        draftSession.finishedAt = endDate
        draftSession.isFinished = true

        if elapsedSeconds > 0 {
            let storedWeight = UserDefaults.standard.double(forKey: "gymbro_user_weight_kg")
            let weightKg = storedWeight > 0 ? storedWeight : 70.0
            let estimate = CalorieEstimator.estimate(durationSeconds: elapsedSeconds, weightKg: weightKg)
            draftSession.calories = estimate.calories
            draftSession.durationMinutes = max(1, Int(elapsedSeconds / 60))
        }

        withAnimation(.easeInOut(duration: 0.3)) { state = .saving }

        let snapshot = draftSession

        Task {
            do {
                // 1. CoreData history — always source of truth
                try await provider.finishTodaysSession(snapshot)

                // 2. Save / update user template so it appears in My list
                let template = snapshot.asTemplate()
                try? await templateRepository.saveTemplate(template)

                withAnimation(.easeInOut(duration: 0.3)) { state = .saved }
                currentSessionProvider.clearCurrentSession()

                // 3. HealthKit — optional, fire-and-forget
                await WorkoutHealthService.shared.saveWorkoutIfEnabled(
                    name: snapshot.name,
                    startDate: snapshot.startedAt,
                    endDate: snapshot.finishedAt ?? endDate,
                    calories: snapshot.calories
                )
            } catch {
                withAnimation(.easeInOut(duration: 0.3)) {
                    state = .failed(error.localizedDescription)
                }
                print("error saving session: \(error)")
            }
        }
    }
}
