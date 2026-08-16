//
//  WorkoutHealthService.swift
//  GymBro
//
import HealthKit
import Foundation

final class WorkoutHealthService {
    static let shared = WorkoutHealthService()
    private let manager = HealthKitManager.shared

    private var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: "gymbro_healthkit_enabled")
    }

    /// Saves a finished workout to Apple Health only if the user has enabled the integration.
    /// Errors are logged but never propagate — CoreData save is the source of truth.
    func saveWorkoutIfEnabled(
        name: String,
        startDate: Date,
        endDate: Date,
        calories: Int
    ) async {
        guard isEnabled, manager.isAvailable else { return }
        do {
            try await saveWorkout(startDate: startDate, endDate: endDate, calories: calories)
            print("[HealthKit] Workout saved: \(name)")
        } catch {
            print("[HealthKit] Failed to save workout '\(name)': \(error.localizedDescription)")
        }
    }

    // MARK: - Private

    private func saveWorkout(startDate: Date, endDate: Date, calories: Int) async throws {
        let store = manager.healthStore
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining

        let builder = HKWorkoutBuilder(
            healthStore: store,
            configuration: configuration,
            device: .local()
        )

        try await begin(builder: builder, start: startDate)

        if calories > 0,
           let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
            let quantity = HKQuantity(unit: .kilocalorie(), doubleValue: Double(calories))
            let sample = HKQuantitySample(
                type: energyType,
                quantity: quantity,
                start: startDate,
                end: endDate
            )
            try await add(samples: [sample], to: builder)
        }

        try await end(builder: builder, at: endDate)
        try await finish(builder: builder)
    }

    // MARK: Continuation wrappers

    private func begin(builder: HKWorkoutBuilder, start: Date) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            builder.beginCollection(withStart: start) { _, error in
                if let error { cont.resume(throwing: error) } else { cont.resume() }
            }
        }
    }

    private func add(samples: [HKSample], to builder: HKWorkoutBuilder) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            builder.add(samples) { _, error in
                if let error { cont.resume(throwing: error) } else { cont.resume() }
            }
        }
    }

    private func end(builder: HKWorkoutBuilder, at date: Date) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            builder.endCollection(withEnd: date) { _, error in
                if let error { cont.resume(throwing: error) } else { cont.resume() }
            }
        }
    }

    @discardableResult
    private func finish(builder: HKWorkoutBuilder) async throws -> HKWorkout {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<HKWorkout, Error>) in
            builder.finishWorkout { workout, error in
                if let error {
                    cont.resume(throwing: error)
                } else if let workout {
                    cont.resume(returning: workout)
                } else {
                    cont.resume(throwing: NSError(
                        domain: "WorkoutHealthService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "finishWorkout returned nil"]
                    ))
                }
            }
        }
    }
}
