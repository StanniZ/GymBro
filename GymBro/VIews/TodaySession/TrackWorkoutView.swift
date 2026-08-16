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
                // Top bar
                topBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                if sessionTimer.isRunning {
                    timerDisplay
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                }

                statsStrip
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)

                Divider().background(Color.white.opacity(0.06))

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach($viewModel.draftSession.exercises) { $exercise in
                            ExerciseList(exercise: $exercise) {
                                viewModel.removeExercise(id: exercise.id)
                            }
                        }
                        addExerciseButton
                    }
                    .padding(16)
                    .padding(.bottom, 24)
                }
            }
        }
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
        .onChange(of: viewModel.state) { newState in
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

    // MARK: - Top bar (session name + action button)

    private var topBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Workout session")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
                Text(todaySession.name)
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            Spacer()
            actionButton
        }
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
                    Circle().fill(Color.red).frame(width: 6, height: 6)
                    Text("Session in progress")
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
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
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.currentday.opacity(0.12))
            .cornerRadius(20)
        }
    }

    @ViewBuilder
    private var finishButton: some View {
        Button {
            viewModel.finishSession(elapsedSeconds: sessionTimer.elapsedTime)
        } label: {
            HStack(spacing: 6) {
                switch viewModel.state {
                case .ready:
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 26)).foregroundColor(.red)
                    Text("Finish").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                case .saving:
                    ProgressView().tint(.currentday)
                    Text("Saving…").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                case .saved:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 26)).foregroundColor(.currentday)
                    Text("Saved!").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                case .failed:
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 26)).foregroundColor(.red)
                    Text("Retry").font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.12))
            .cornerRadius(20)
        }
        .disabled(viewModel.state == .saving)
    }
}
