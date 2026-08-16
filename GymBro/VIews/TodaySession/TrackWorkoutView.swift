//
//  TrackWorkoutView.swift
//  GymBro
//
//  Created by macbook on 07/09/2025.
//
import SwiftUI

struct TrackWorkoutView: View {
    @EnvironmentObject var viewModel: TodaySessionViewModel
    @EnvironmentObject var sessionTimer: SessionTimerViewModel
    @Environment(\.dismiss) private var dismiss

    private var todaySession: TrainingSessionModel {
        viewModel.draftSession
    }

    var body: some View {
        VStack(spacing: 20) {
            // Top row: header + start/finish button
            HStack(alignment: .top) {
                sessionHeader
                Spacer()
                actionButton
            }

            // Timer display appears below header when running
            if sessionTimer.isRunning {
                timerDisplay
            }

            VStack(spacing: 12) {
                HorizontalDottedLineFull()
                parametersSession
                HorizontalDottedLineFull()
            }

            ScrollView(.vertical, showsIndicators: false) {
                exercisesSession
                    .padding(.bottom, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.backmain)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                title
            }
        }
        .onChange(of: viewModel.state) { newState in
            if newState == .saved {
                sessionTimer.finishSession()
                dismiss()
            }
        }
    }

    private var title: some View {
        Text("Track session")
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white)
    }

    private var sessionHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Workout session")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
            Text(todaySession.name)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
        }
    }

    private var timerDisplay: some View {
        VStack(spacing: 6) {
            Text(sessionTimer.formattedTime)
                .font(.system(size: 52, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.red)
                    .frame(width: 7, height: 7)
                Text("Session in progress")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 4)
    }

    private var parametersSession: some View {
        HStack {
            parameterSession(value: "\(todaySession.countExercise)", title: "Total Exercises")
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
            parameterSession(value: "\(todaySession.durationMinutes)", title: "Duration")
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
            parameterSession(value: "\(todaySession.calories)", title: "Calories")
        }
    }

    private func parameterSession(value: String, title: String) -> some View {
        VStack(alignment: .center, spacing: 8) {
            Text(value)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var exercisesSession: some View {
        VStack(spacing: 16) {
            ForEach($viewModel.draftSession.exercises) { $exercise in
                ExerciseList(exercise: $exercise)
            }
        }
    }

    // MARK: - Top action button (compact, top-right)

    @ViewBuilder
    private var actionButton: some View {
        if sessionTimer.isRunning {
            finishButton
        } else {
            startButton
        }
    }

    private var startButton: some View {
        Button {
            viewModel.startSession()
            sessionTimer.start()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.currentday)
                Text("Start")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }

    @ViewBuilder
    private var finishButton: some View {
        Button {
            viewModel.finishSession(elapsedSeconds: sessionTimer.elapsedTime)
        } label: {
            switch viewModel.state {
            case .ready:
                HStack(spacing: 6) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.red)
                    Text("Finish")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            case .saving:
                HStack(spacing: 6) {
                    ProgressView()
                        .tint(.currentday)
                    Text("Saving...")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            case .saved:
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.currentday)
                    Text("Saved!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            case .failed:
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.red)
                    Text("Retry")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(viewModel.state == .saving)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 18))
        }
    }
}
