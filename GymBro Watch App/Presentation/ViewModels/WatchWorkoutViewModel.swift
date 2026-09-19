//
//  WatchWorkoutViewModel.swift
//  GymBro Watch App
//
//  Created by Codex on 14/09/2026.
//

import Combine
import Foundation

@MainActor
final class WatchWorkoutViewModel: ObservableObject {
    @Published private(set) var templates: [WatchWorkoutTemplate] = []
    @Published var activeSession: WatchWorkoutSession?
    @Published private(set) var syncStatus: String = ""
    @Published private(set) var healthMetrics = WatchWorkoutHealthMetrics()

    private let loadTemplatesUseCase: LoadWatchWorkoutTemplatesUseCase
    private let submitFinishedWorkoutUseCase: SubmitFinishedWatchWorkoutUseCase
    private let healthService: WatchWorkoutHealthService

    init(repository: WatchWorkoutRepository, healthService: WatchWorkoutHealthService) {
        self.loadTemplatesUseCase = LoadWatchWorkoutTemplatesUseCase(repository: repository)
        self.submitFinishedWorkoutUseCase = SubmitFinishedWatchWorkoutUseCase(repository: repository)
        self.healthService = healthService
        self.healthService.onMetricsUpdated = { [weak self] metrics in
            self?.healthMetrics = metrics
        }
    }

    convenience init() {
        let connectivityClient = WatchConnectivityClient()
        let repository = DefaultWatchWorkoutRepository(connectivityClient: connectivityClient)
        let healthService = WatchWorkoutHealthService()
        self.init(repository: repository, healthService: healthService)
    }

    var hasActiveWorkout: Bool {
        activeSession != nil
    }

    var elapsedText: String {
        let elapsed = elapsedSeconds()
        let minutes = elapsed / 60
        let seconds = elapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var heartRateText: String {
        guard activeSession?.isPaused == false, let heartRate = healthMetrics.heartRate else { return "--" }
        return "\(Int(heartRate.rounded()))"
    }

    var activeCaloriesText: String {
        guard let activeEnergy = healthMetrics.activeEnergy else { return "--" }
        return "\(Int(activeEnergy.rounded()))"
    }

    func loadTemplates() async {
        do {
            templates = try await loadTemplatesUseCase.execute()
            syncStatus = ""
        } catch {
            templates = WatchWorkoutFixtures.templates
            syncStatus = "Using offline workouts"
        }
    }

    func startWorkout(_ template: WatchWorkoutTemplate) {
        let session = WatchWorkoutSession(template: template)
        activeSession = session
        healthMetrics = WatchWorkoutHealthMetrics()

        Task {
            await healthService.startWorkout(at: session.startedAt)
        }
    }

    func finishWorkout() {
        guard let session = activeSession else { return }
        activeSession = nil

        Task {
            let metrics = await healthService.finishWorkout()
            do {
                try await submitFinishedWorkoutUseCase.execute(session: session, activeCalories: metrics.activeEnergy)
                syncStatus = "Workout queued for iPhone"
            } catch {
                syncStatus = "Workout saved on Watch"
            }
        }
    }

    func togglePause() {
        guard var session = activeSession else { return }

        if session.isPaused {
            if let pausedAt = session.pausedAt {
                session.pausedDuration += Date().timeIntervalSince(pausedAt)
            }
            session.pausedAt = nil
            session.isPaused = false
            healthService.resumeWorkout()
        } else {
            session.pausedAt = Date()
            session.isPaused = true
            healthService.pauseWorkout()
        }

        activeSession = session
    }

    func setCurrentExercise(_ exercise: WatchSessionExercise) {
        guard let index = activeSession?.exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
        activeSession?.currentExerciseIndex = index
    }

    func addSet(to exerciseID: UUID) {
        guard let exerciseIndex = activeSession?.exercises.firstIndex(where: { $0.id == exerciseID }) else { return }
        let sets = activeSession?.exercises[exerciseIndex].sets ?? []
        let lastSet = sets.last
        let newSet = WatchExerciseSet(
            setNumber: sets.count + 1,
            weight: lastSet?.weight ?? 0,
            reps: lastSet?.reps ?? 10,
            isCompleted: false
        )
        activeSession?.exercises[exerciseIndex].sets.append(newSet)
    }

    func removeLastSet(from exerciseID: UUID) {
        guard let exerciseIndex = activeSession?.exercises.firstIndex(where: { $0.id == exerciseID }),
              let setCount = activeSession?.exercises[exerciseIndex].sets.count,
              setCount > 1 else { return }

        activeSession?.exercises[exerciseIndex].sets.removeLast()
        renumberSets(for: exerciseIndex)
    }

    func updateSet(exerciseID: UUID, setID: UUID, weight: Double? = nil, reps: Int? = nil, isCompleted: Bool? = nil) {
        guard let exerciseIndex = activeSession?.exercises.firstIndex(where: { $0.id == exerciseID }),
              let setIndex = activeSession?.exercises[exerciseIndex].sets.firstIndex(where: { $0.id == setID }) else { return }

        if let weight {
            activeSession?.exercises[exerciseIndex].sets[setIndex].weight = max(weight, 0)
        }

        if let reps {
            activeSession?.exercises[exerciseIndex].sets[setIndex].reps = max(reps, 1)
        }

        if let isCompleted {
            activeSession?.exercises[exerciseIndex].sets[setIndex].isCompleted = isCompleted
        }
    }

    func toggleExerciseFinished(_ exerciseID: UUID) {
        guard let exerciseIndex = activeSession?.exercises.firstIndex(where: { $0.id == exerciseID }) else { return }
        activeSession?.exercises[exerciseIndex].isFinished.toggle()
    }

    func completedSetsCount(for exercise: WatchSessionExercise) -> Int {
        exercise.sets.filter(\.isCompleted).count
    }

    private func elapsedSeconds(now: Date = Date()) -> Int {
        guard let activeSession else { return 0 }

        let currentPausedDuration: TimeInterval
        if activeSession.isPaused, let pausedAt = activeSession.pausedAt {
            currentPausedDuration = activeSession.pausedDuration + now.timeIntervalSince(pausedAt)
        } else {
            currentPausedDuration = activeSession.pausedDuration
        }

        return max(Int(now.timeIntervalSince(activeSession.startedAt) - currentPausedDuration), 0)
    }

    private func renumberSets(for exerciseIndex: Int) {
        guard let count = activeSession?.exercises[exerciseIndex].sets.count else { return }
        for index in 0..<count {
            activeSession?.exercises[exerciseIndex].sets[index].setNumber = index + 1
        }
    }
}
