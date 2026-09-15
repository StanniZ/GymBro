//
//  WorkoutControlsView.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import SwiftUI

struct WorkoutControlsView: View {
    @EnvironmentObject private var viewModel: WatchWorkoutViewModel

    let session: WatchWorkoutSession

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                header
                actionGrid
                metricsGrid
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .background(WatchTheme.background)
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: session.isPaused ? "pause.circle.fill" : "figure.strengthtraining.traditional")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(session.isPaused ? .yellow : WatchTheme.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.isPaused ? "Paused" : "Workout")
                    .font(WatchTypography.title)
                    .foregroundStyle(.white)
                TimelineView(.periodic(from: .now, by: 1)) { _ in
                    Text(viewModel.elapsedText)
                        .font(WatchTypography.caption)
                        .foregroundStyle(WatchTheme.muted)
                        .monospacedDigit()
                }
            }

            Spacer()
        }
        .padding(10)
        .background(WatchTheme.panel, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var actionGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            controlButton(
                title: "End",
                systemImage: "xmark",
                background: WatchTheme.danger,
                foreground: .white,
                action: viewModel.finishWorkout
            )

            controlButton(
                title: session.isPaused ? "Resume" : "Pause",
                systemImage: session.isPaused ? "play.fill" : "pause.fill",
                background: session.isPaused ? WatchTheme.accent : .yellow,
                foreground: .black,
                action: viewModel.togglePause
            )

            controlButton(
                title: "Lock",
                systemImage: "drop.fill",
                background: .blue,
                foreground: .white,
                action: {}
            )

            controlButton(
                title: "New",
                systemImage: "plus",
                background: WatchTheme.panelSecondary,
                foreground: .white,
                action: {}
            )
        }
    }

    private var metricsGrid: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                metricTile(title: "Heart", value: viewModel.heartRateText, unit: "BPM", color: .red)
                metricTile(title: "Active", value: viewModel.activeCaloriesText, unit: "CAL", color: .orange)
            }

            HStack(spacing: 8) {
                metricTile(title: "Exercises", value: completedExercisesText, unit: "DONE", color: WatchTheme.accent)
                metricTile(title: "Sets", value: completedSetsText, unit: "DONE", color: .cyan)
            }
        }
    }

    private var completedExercisesText: String {
        let finished = session.exercises.filter(\.isFinished).count
        return "\(finished)/\(session.exercises.count)"
    }

    private var completedSetsText: String {
        let sets = session.exercises.flatMap(\.sets)
        let completed = sets.filter(\.isCompleted).count
        return "\(completed)/\(sets.count)"
    }

    private func controlButton(
        title: String,
        systemImage: String,
        background: Color,
        foreground: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: 42, height: 42)
                    .background(background, in: Circle())
                    .foregroundStyle(foreground)

                Text(title)
                    .font(WatchTypography.caption)
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    private func metricTile(title: String, value: String, unit: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title.uppercased())
                .font(WatchTypography.micro)
                .foregroundStyle(WatchTheme.muted)

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(WatchTypography.metric)
                    .foregroundStyle(color)
                    .monospacedDigit()
                    .minimumScaleFactor(0.75)

                Text(unit)
                    .font(WatchTypography.micro)
                    .foregroundStyle(WatchTheme.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(WatchTheme.panel, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
