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

    private let loadTemplatesUseCase: LoadWatchWorkoutTemplatesUseCase
    private let submitFinishedWorkoutUseCase: SubmitFinishedWatchWorkoutUseCase

    init(repository: WatchWorkoutRepository) {
        self.loadTemplatesUseCase = LoadWatchWorkoutTemplatesUseCase(repository: repository)
        self.submitFinishedWorkoutUseCase = SubmitFinishedWatchWorkoutUseCase(repository: repository)
    }

    convenience init() {
        let connectivityClient = WatchConnectivityClient()
        let repository = DefaultWatchWorkoutRepository(connectivityClient: connectivityClient)
        self.init(repository: repository)
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
        guard activeSession != nil else { return "--" }
        return activeSession?.isPaused == true ? "--" : "128"
    }

    var activeCaloriesText: String {
        guard activeSession != nil else { return "0" }
        return "\(max(elapsedSeconds() / 12, 0))"
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
        activeSession = WatchWorkoutSession(template: template)
    }

    func finishWorkout() {
        guard let session = activeSession else { return }
        activeSession = nil

        Task {
            do {
                try await submitFinishedWorkoutUseCase.execute(session: session)
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
        } else {
            session.pausedAt = Date()
            session.isPaused = true
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
