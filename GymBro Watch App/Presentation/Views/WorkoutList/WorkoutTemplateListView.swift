//
//  WorkoutTemplateListView.swift
//  GymBro Watch App
//
//  Created by Codex on 14/09/2026.
//

import SwiftUI

struct WorkoutTemplateListView: View {
    @EnvironmentObject private var viewModel: WatchWorkoutViewModel

    var body: some View {
        NavigationStack {
            List {
                header
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 6, bottom: 6, trailing: 6))

                ForEach(viewModel.templates) { template in
                    WorkoutTemplateRow(template: template) {
                        viewModel.startWorkout(template)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                }
            }
            .listStyle(.carousel)
            .scrollContentBackground(.hidden)
            .background(WatchTheme.background)
            .navigationTitle("GymBro")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Choose workout")
                .font(WatchTypography.largeTitle)
                .foregroundStyle(.white)
            Text("Start from your watch")
                .font(WatchTypography.caption)
                .foregroundStyle(WatchTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WorkoutTemplateRow: View {
    let template: WatchWorkoutTemplate
    let startAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.title)
                        .font(WatchTypography.headline)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    Text(template.subtitle)
                        .font(WatchTypography.caption)
                        .foregroundStyle(WatchTheme.muted)
                        .lineLimit(2)
                }

                Spacer(minLength: 6)

                Text("\(template.estimatedMinutes)m")
                    .font(WatchTypography.micro)
                    .foregroundStyle(WatchTheme.accent)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(WatchTheme.accent.opacity(0.14), in: Capsule())
            }

            HStack(spacing: 8) {
                Label("\(template.exercises.count)", systemImage: "figure.strengthtraining.traditional")
                    .labelStyle(.titleAndIcon)
                    .font(WatchTypography.caption)
                    .foregroundStyle(WatchTheme.muted)

                Spacer()

                Button(action: startAction) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(width: 34, height: 28)
                        .background(WatchTheme.accent, in: Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Start \(template.title)")
            }
        }
        .padding(12)
        .background(WatchTheme.panel, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.06), lineWidth: 1)
        )
    }
}
