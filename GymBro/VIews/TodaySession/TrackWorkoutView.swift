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
    @EnvironmentObject var historyVM: HistorySessionViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showExercisePicker = false

    private var todaySession: TrainingSessionModel { viewModel.draftSession }

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                Divider().background(Color.white.opacity(0.06))

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        if sessionTimer.isRunning || sessionTimer.isPaused {
                            timerDisplay
                        }
                        statsStrip
                        ForEach($viewModel.draftSession.exercises) { $exercise in
                            ExerciseList(exercise: $exercise) {
                                viewModel.removeExercise(id: exercise.id)
                            }
                        }
                        addExerciseButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .dismissKeyboardOnTap()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { backButton }
            ToolbarItem(placement: .principal) { navTitle }
        }
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showExercisePicker) {
            ExercisePickerView { definitions in
                viewModel.addExercises(definitions)
            }
        }
        .task {
            if historyVM.sessions.isEmpty { await historyVM.load() }
        }
        .onChange(of: viewModel.state) { _, newState in
            if newState == .saved {
                sessionTimer.finishSession()
                dismiss()
            }
        }
    }

    // MARK: - Nav

    private var navTitle: some View {
        Text("Track session")
            .font(AppFont.body)
            .foregroundColor(.white)
    }

    private var backButton: some View {
        Button { dismiss() } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .font(.system(size: 18))
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Workout session")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
                Text(todaySession.name)
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }

            actionButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Timer

    private var timerDisplay: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Text(sessionTimer.formattedTime)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                HStack(spacing: 5) {
                    Circle()
                        .fill(sessionTimer.isPaused ? Color.yellow : Color.red)
                        .frame(width: 6, height: 6)
                    Text(sessionTimer.isPaused ? "Session paused" : "Session in progress")
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }

    // MARK: - Stats strip

    private var statsStrip: some View {
        HStack(spacing: 0) {
            statCell(value: "\(todaySession.countExercise)", label: "Exercises")
            Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 28)
            statCell(value: "\(todaySession.durationMinutes)", label: "Est. min")
            Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 28)
            statCell(value: "\(todaySession.calories)", label: "Est. kcal")
        }
        .padding(.vertical, 10)
        .background(Color.backbutton)
        .cornerRadius(14)
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Add exercise button

    private var addExerciseButton: some View {
        Button { showExercisePicker = true } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.currentday)
                Text("Add Exercise")
                    .font(AppFont.subheadline)
                    .foregroundColor(.currentday)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.25))
            }
            .padding(16)
            .background(Color.backbutton)
            .cornerRadius(16)
        }
    }

    // MARK: - Action button (Start / Finish)

    @ViewBuilder
    private var actionButton: some View {
        if sessionTimer.isRunning || sessionTimer.isPaused {
            HStack(spacing: 10) {
                finishButton
                pauseButton
            }
        } else {
            startButton
        }
    }

    private var startButton: some View {
        Button {
            viewModel.startSession()
            sessionTimer.start()
        } label: {
            actionButtonLabel(
                title: "Start",
                icon: "play.fill",
                color: .currentday
            )
        }
    }

    private var pauseButton: some View {
        Button {
            if sessionTimer.isRunning {
                sessionTimer.pause()
            } else {
                sessionTimer.start()
            }
        } label: {
            actionButtonLabel(
                title: sessionTimer.isRunning ? "Pause" : "Resume",
                icon: sessionTimer.isRunning ? "pause.fill" : "play.fill",
                color: .yellow
            )
        }
        .disabled(viewModel.state == .saving)
    }

    @ViewBuilder
    private var finishButton: some View {
        Button {
            viewModel.finishSession(elapsedSeconds: sessionTimer.elapsedTime)
        } label: {
            finishButtonLabel
        }
        .disabled(viewModel.state == .saving)
    }

    @ViewBuilder
    private var finishButtonLabel: some View {
        switch viewModel.state {
        case .ready:
            actionButtonLabel(title: "Finish", icon: "stop.fill", color: .red)
        case .saving:
            actionButtonLabel(title: "Saving", icon: nil, color: .currentday, showsProgress: true)
        case .saved:
            actionButtonLabel(title: "Saved", icon: "checkmark", color: .currentday)
        case .failed:
            actionButtonLabel(title: "Retry", icon: "exclamationmark", color: .red)
        }
    }

    private func actionButtonLabel(
        title: String,
        icon: String?,
        color: Color,
        showsProgress: Bool = false
    ) -> some View {
        HStack(spacing: 6) {
            if showsProgress {
                ProgressView()
                    .tint(color)
                    .scaleEffect(0.8)
            } else if let icon {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
            }

            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(width: 104, height: 42)
        .background(color.opacity(0.14))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.28), lineWidth: 0.8)
        )
        .cornerRadius(16)
        .contentShape(RoundedRectangle(cornerRadius: 16))
    }
}
