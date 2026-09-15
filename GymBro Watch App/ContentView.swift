//
//  ContentView.swift
//  GymBro Watch App
//
//  Created by macbook on 14/09/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: WatchWorkoutViewModel

    var body: some View {
        Group {
            if viewModel.hasActiveWorkout {
                ActiveWorkoutView()
            } else {
                WorkoutTemplateListView()
            }
        }
        .background(WatchTheme.background)
        .task {
            await viewModel.loadTemplates()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchWorkoutViewModel())
}
