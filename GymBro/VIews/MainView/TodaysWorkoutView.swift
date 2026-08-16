//
//  TodaysWorkoutView.swift
//  GymBro
//
//  Created by macbook on 03/06/2025.

import SwiftUI

struct TodaysWorkoutView: View {

    @ObservedObject var currentSession: CurrentSessionManager
    @EnvironmentObject var sessionTimer: SessionTimerViewModel

    private var hasSession: Bool {
        !currentSession.currentSession.exercises.isEmpty
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                header
                Spacer()
            }

            if hasSession || sessionTimer.isRunning {
                NavigationLink(destination: TrackWorkoutView()) {
                    ZStack {
                        if sessionTimer.isRunning {
                            activeSessionCard
                        } else {
                            WorkoutContent(session: currentSession.currentSession)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.backbutton)
                    .cornerRadius(20)
                }
            } else {
                emptySessionCard
            }
        }
    }

    private var header: some View {
        Text("Today's Workout")
            .font(AppFont.headline)
            .foregroundColor(.white)
    }

    private var activeSessionCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                    Text("ACTIVE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.red)
                }
                Text(currentSession.currentSession.name)
                    .font(AppFont.body)
                    .foregroundColor(.white)
                Text("\(currentSession.currentSession.countExercise) exercises")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.weekDay)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(sessionTimer.formattedTime)
                    .font(.system(size: 22, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color.currentday)
                HStack(spacing: 4) {
                    Text("Tap to continue")
                        .font(AppFont.caption)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.white.opacity(0.5))
                }
            }
        }
        .padding(16)
    }

    private var emptySessionCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 44))
                .foregroundStyle(Color.white.opacity(0.2))
            VStack(spacing: 6) {
                Text("No workout selected")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.7))
                Text("Pick a template from Build Session above")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.35))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .background(Color.backbutton)
        .cornerRadius(20)
    }
}

struct WorkoutContent: View {

    let session: TrainingSessionModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading) {
                    muscleName
                    listOfExercises
                }
                Spacer()
                calories
            }
            .padding(12)
        }
    }

    private var calories: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("\(session.calories)")
                .font(AppFont.subheadline)
                .foregroundStyle(Color.currentday)
            HStack(spacing: 2) {
                Text("cal")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.weekDay)
                Image(systemName: "flame.fill")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.firecolor)
            }
        }
    }

    private var muscleName: some View {
        Text(session.name)
            .font(AppFont.body)
            .foregroundColor(.white)
            .padding(.bottom, 8)
    }

    private var listOfExercises: some View {
        ForEach(session.exercises.indices, id: \.self) { index in
            ExerciseRow(exercise: session.exercises[index])
            if index < session.exercises.count - 1 {
                HorizontalDottedLine()
            }
        }
    }
}

//MARK: - List of exercises
struct ExerciseRow: View {

    let exercise: SessionExerciseModel

    private var exerciseName: String {
        ExerciseLoader.byID[exercise.exerciseID]?.name ?? "Exercise \(exercise.exerciseID)"
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exerciseName)
                    .font(AppFont.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("\(exercise.sets.count) sets")
                    .font(AppFont.caption)
                    .foregroundColor(.weekDay)
                    .lineLimit(1)
            }
        }
    }
}
