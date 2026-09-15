//
//  ActiveWorkoutView.swift
//  GymBro Watch App
//
//  Created by Codex on 14/09/2026.
//

import SwiftUI

struct ActiveWorkoutView: View {
    @EnvironmentObject private var viewModel: WatchWorkoutViewModel
    @State private var selectedPage = 0

    var body: some View {
        if let session = viewModel.activeSession {
            TabView(selection: $selectedPage) {
                WorkoutControlsView(session: session)
                    .tag(-1)

                exercisePager(session: session)
                    .tag(0)
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .background(WatchTheme.background)
        } else {
            WorkoutTemplateListView()
        }
    }

    private func exercisePager(session: WatchWorkoutSession) -> some View {
        TabView(selection: currentExerciseSelection) {
            ForEach(Array(session.exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseWorkoutPage(
                    exercise: exercise,
                    exerciseNumber: index + 1,
                    totalExercises: session.exercises.count
                )
                .tag(index)
            }
        }
        .tabViewStyle(.verticalPage)
        .background(WatchTheme.background)
    }

    private var currentExerciseSelection: Binding<Int> {
        Binding(
            get: { viewModel.activeSession?.currentExerciseIndex ?? 0 },
            set: { viewModel.activeSession?.currentExerciseIndex = max($0, 0) }
        )
    }
}
