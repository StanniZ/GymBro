//
//  ExerciseWorkoutPage.swift
//  GymBro Watch App
//
//  Created by Codex on 14/09/2026.
//

import SwiftUI

struct ExerciseWorkoutPage: View {
    @EnvironmentObject private var viewModel: WatchWorkoutViewModel
    @State private var activeEditor: SetEditorSelection?

    let exercise: WatchSessionExercise
    let exerciseNumber: Int
    let totalExercises: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                header

                ForEach(exercise.sets) { set in
                    SetEditorRow(activeEditor: $activeEditor, exerciseID: exercise.id, set: set)
                }

                setActions
                finishExerciseButton
            }
            .padding(10)
        }
        .background(WatchTheme.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(exerciseNumber)/\(totalExercises)")
                    .font(WatchTypography.micro)
                    .foregroundStyle(WatchTheme.accent)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(WatchTheme.accent.opacity(0.14), in: Capsule())

                Spacer()

                if exercise.isFinished {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(WatchTheme.accent)
                }
            }

            Text(exercise.name)
                .font(WatchTypography.largeTitle)
                .foregroundStyle(.white)
                .lineLimit(2)

            HStack(spacing: 6) {
                Text(exercise.muscleGroup)
                Text("•")
                Text("\(viewModel.completedSetsCount(for: exercise))/\(exercise.sets.count) sets")
            }
            .font(WatchTypography.caption)
            .foregroundStyle(WatchTheme.muted)
        }
        .padding(12)
        .background(WatchTheme.panel, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var setActions: some View {
        HStack(spacing: 8) {
            Button {
                activeEditor = nil
                viewModel.removeLastSet(from: exercise.id)
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 13, weight: .bold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(WatchTheme.panelSecondary)
            .disabled(exercise.sets.count <= 1)
            .accessibilityLabel("Remove set")

            Button {
                activeEditor = nil
                viewModel.addSet(to: exercise.id)
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 13, weight: .bold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(WatchTheme.accent)
            .accessibilityLabel("Add set")
        }
    }

    private var finishExerciseButton: some View {
        Button {
            activeEditor = nil
            viewModel.toggleExerciseFinished(exercise.id)
        } label: {
            Label(exercise.isFinished ? "Reopen" : "Done", systemImage: exercise.isFinished ? "arrow.uturn.backward" : "checkmark")
                .font(WatchTypography.body)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(exercise.isFinished ? WatchTheme.panelSecondary : WatchTheme.accent)
    }
}
