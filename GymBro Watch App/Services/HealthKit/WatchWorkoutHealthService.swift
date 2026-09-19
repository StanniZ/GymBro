//
//  WatchWorkoutHealthService.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Foundation
import HealthKit

@MainActor
final class WatchWorkoutHealthService: NSObject {
    var onMetricsUpdated: ((WatchWorkoutHealthMetrics) -> Void)?

    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private var startDate: Date?

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func startWorkout(at date: Date = Date()) async {
        guard isAvailable else { return }

        do {
            try await requestAuthorization()

            let configuration = HKWorkoutConfiguration()
            configuration.activityType = .traditionalStrengthTraining
            configuration.locationType = .indoor

            let session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            let builder = session.associatedWorkoutBuilder()
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            session.delegate = self
            builder.delegate = self

            workoutSession = session
            workoutBuilder = builder
            startDate = date

            try await beginCollection(builder: builder, at: date)
            session.startActivity(with: date)
        } catch {
            clearWorkout()
            onMetricsUpdated?(WatchWorkoutHealthMetrics())
        }
    }

    func pauseWorkout() {
        workoutSession?.pause()
    }

    func resumeWorkout() {
        workoutSession?.resume()
    }

    func finishWorkout(at date: Date = Date()) async -> WatchWorkoutHealthMetrics {
        guard let session = workoutSession, let builder = workoutBuilder else {
            return WatchWorkoutHealthMetrics()
        }

        session.end()

        do {
            try await endCollection(builder: builder, at: date)
            _ = try await finishWorkout(builder: builder)
        } catch {
            clearWorkout()
            return WatchWorkoutHealthMetrics()
        }

        let metrics = currentMetrics()
        clearWorkout()
        return metrics
    }

    private func requestAuthorization() async throws {
        let workoutType = HKObjectType.workoutType()
        let activeEnergy = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate)

        var shareTypes: Set<HKSampleType> = [workoutType]
        if let activeEnergy {
            shareTypes.insert(activeEnergy)
        }

        var readTypes: Set<HKObjectType> = []
        if let activeEnergy {
            readTypes.insert(activeEnergy)
        }
        if let heartRate {
            readTypes.insert(heartRate)
        }

        try await healthStore.requestAuthorization(toShare: shareTypes, read: readTypes)
    }

    private func currentMetrics() -> WatchWorkoutHealthMetrics {
        guard let builder = workoutBuilder else { return WatchWorkoutHealthMetrics() }

        let heartRateValue: Double?
        if let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
           let statistics = builder.statistics(for: heartRateType),
           let quantity = statistics.mostRecentQuantity() {
            heartRateValue = quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
        } else {
            heartRateValue = nil
        }

        let activeEnergyValue: Double?
        if let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
           let statistics = builder.statistics(for: energyType),
           let quantity = statistics.sumQuantity() {
            activeEnergyValue = quantity.doubleValue(for: .kilocalorie())
        } else {
            activeEnergyValue = nil
        }

        return WatchWorkoutHealthMetrics(
            heartRate: heartRateValue,
            activeEnergy: activeEnergyValue
        )
    }

    private func publishMetrics() {
        onMetricsUpdated?(currentMetrics())
    }

    private func clearWorkout() {
        workoutSession?.delegate = nil
        workoutBuilder?.delegate = nil
        workoutSession = nil
        workoutBuilder = nil
        startDate = nil
    }

    private func beginCollection(builder: HKLiveWorkoutBuilder, at date: Date) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            builder.beginCollection(withStart: date) { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    private func endCollection(builder: HKLiveWorkoutBuilder, at date: Date) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            builder.endCollection(withEnd: date) { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    private func finishWorkout(builder: HKLiveWorkoutBuilder) async throws -> HKWorkout {
        try await withCheckedThrowingContinuation { continuation in
            builder.finishWorkout { workout, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if let workout {
                    continuation.resume(returning: workout)
                } else {
                    continuation.resume(throwing: WatchWorkoutHealthError.missingWorkout)
                }
            }
        }
    }
}

extension WatchWorkoutHealthService: HKWorkoutSessionDelegate {
    nonisolated func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState,
        date: Date
    ) {}

    nonisolated func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        Task { @MainActor in
            clearWorkout()
            onMetricsUpdated?(WatchWorkoutHealthMetrics())
        }
    }
}

extension WatchWorkoutHealthService: HKLiveWorkoutBuilderDelegate {
    nonisolated func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        Task { @MainActor in
            publishMetrics()
        }
    }

    nonisolated func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        Task { @MainActor in
            publishMetrics()
        }
    }
}

struct WatchWorkoutHealthMetrics: Equatable {
    var heartRate: Double?
    var activeEnergy: Double?
}

enum WatchWorkoutHealthError: Error {
    case missingWorkout
}
