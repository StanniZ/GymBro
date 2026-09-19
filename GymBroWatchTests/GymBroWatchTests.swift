//
//  GymBroWatchTests.swift
//  GymBroWatchTests
//
//  Created by macbook on 16/09/2026.
//

import Foundation
import Testing
@testable import GymBro_Watch_App_Watch_App

struct GymBroWatchTests {

    @Test func workoutTemplatePayloadRoundTripsToDomainModel() {
        let planID = UUID(uuidString: "00000000-0000-0000-0000-000000000101")!
        let payload = WatchWorkoutTemplatePayload(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000100")!,
            title: "Leg Day",
            subtitle: "Quads / Hamstrings",
            estimatedMinutes: 50,
            exercises: [
                WatchExercisePlanPayload(
                    id: planID,
                    exerciseID: 42,
                    name: "Squat",
                    muscleGroup: "Legs",
                    targetSets: 4,
                    defaultWeight: 100,
                    defaultReps: 6
                )
            ]
        )

        let template = WatchWorkoutTemplate(payload: payload)

        #expect(template.title == "Leg Day")
        #expect(template.exercises.first?.id == planID)
        #expect(template.exercises.first?.exerciseID == 42)
        #expect(template.exercises.first?.defaultWeight == 100)
        #expect(template.payload == payload)
    }

    @Test func workoutSessionCreatesEditableSetsFromTemplatePlan() throws {
        let plan = WatchExercisePlan(
            exerciseID: 7,
            name: "Bench Press",
            muscleGroup: "Chest",
            targetSets: 3,
            defaultWeight: 60.5,
            defaultReps: 8
        )
        let template = WatchWorkoutTemplate(
            title: "Push Day",
            subtitle: "Chest",
            estimatedMinutes: 45,
            exercises: [plan]
        )

        let session = WatchWorkoutSession(template: template)
        let exercise = try #require(session.exercises.first)

        #expect(session.title == "Push Day")
        #expect(exercise.exerciseID == 7)
        #expect(exercise.sets.count == 3)
        #expect(exercise.sets.allSatisfy { $0.weight == 60.5 })
        #expect(exercise.sets.allSatisfy { $0.reps == 8 })
        #expect(exercise.sets.map(\.setNumber) == [1, 2, 3])
    }

    @Test func finishedPayloadCarriesExerciseIDCompletedSetsAndActiveCalories() throws {
        let startedAt = Date(timeIntervalSince1970: 1_800_000_000)
        let finishedAt = startedAt.addingTimeInterval(35 * 60)
        let plan = WatchExercisePlan(
            exerciseID: 88,
            name: "Deadlift",
            muscleGroup: "Back",
            targetSets: 1,
            defaultWeight: 120,
            defaultReps: 5
        )
        var session = WatchWorkoutSession(
            template: WatchWorkoutTemplate(
                title: "Pull Day",
                subtitle: "Back",
                estimatedMinutes: 40,
                exercises: [plan]
            ),
            startedAt: startedAt
        )
        session.exercises[0].isFinished = true
        session.exercises[0].sets[0].isCompleted = true
        session.exercises[0].sets[0].weight = 125.5
        session.exercises[0].sets[0].reps = 4

        let payload = session.finishedPayload(finishedAt: finishedAt, activeCalories: 180)
        let exercise = try #require(payload.exercises.first)
        let set = try #require(exercise.sets.first)

        #expect(payload.title == "Pull Day")
        #expect(payload.startedAt == startedAt)
        #expect(payload.finishedAt == finishedAt)
        #expect(payload.activeCalories == 180)
        #expect(exercise.exerciseID == 88)
        #expect(exercise.isFinished)
        #expect(set.weight == 125.5)
        #expect(set.reps == 4)
        #expect(set.isCompleted)
    }

    @Test func healthMetricsStartEmptyWhenHealthKitIsUnavailableOrUnauthorized() {
        let metrics = WatchWorkoutHealthMetrics()

        #expect(metrics.heartRate == nil)
        #expect(metrics.activeEnergy == nil)
    }
}
