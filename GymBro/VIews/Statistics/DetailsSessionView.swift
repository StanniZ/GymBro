//
//  DetailsSessionView.swift
//  GymBro
//
//  Created by macbook on 20/09/2025.
//
import SwiftUI

struct DetailsSessionView: View {
    @Environment(\.dismiss) private var dismiss
    let session: TrainingSessionModel

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    sessionInfoCard
                    exercisesSection
                }
                .padding(16)
                .padding(.bottom, 32)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Session Details")
                    .font(AppFont.body)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Session Info Card

    private var sessionInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Name + date
            VStack(alignment: .leading, spacing: 6) {
                Text(session.name)
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                if let date = session.finishedAt {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.35))
                        Text(date.dateForSessionHistory)
                            .font(AppFont.caption)
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
            }

            Divider().background(Color.white.opacity(0.06))

            // Stats row
            HStack(spacing: 0) {
                statCell(value: "\(session.durationMinutes)", unit: "min", label: "Duration")
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                statCell(value: "\(session.calories)", unit: "kcal", label: "Burned")
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                statCell(value: "\(session.exercises.count)", unit: "", label: "Exercises")
            }
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private func statCell(value: String, unit: String, label: String) -> some View {
        VStack(spacing: 3) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                if !unit.isEmpty {
                    Text(unit)
                        .font(AppFont.caption)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            Text(label)
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Exercises Section

    private var exercisesSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Exercises")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(session.exercises.count) total")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
            }

            VStack(spacing: 10) {
                ForEach(session.exercises.indices, id: \.self) { i in
                    ExerciseDetailsCard(exercise: session.exercises[i], index: i + 1)
                }
            }
        }
    }
}

// MARK: - Exercise Details Card

struct ExerciseDetailsCard: View {
    let exercise: SessionExerciseModel
    let index: Int

    private var name: String {
        ExerciseLoader.byID[exercise.exerciseID]?.name ?? "Exercise \(exercise.exerciseID)"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 10) {
                Text("\(index)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 24, height: 24)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(6)

                Text(name)
                    .font(AppFont.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
                Text("\(exercise.sets.count) sets")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)

            if !exercise.sets.isEmpty {
                Divider().background(Color.white.opacity(0.06))

                // Sets table header
                HStack {
                    Text("Set").frame(width: 28, alignment: .leading)
                    Text("Weight").frame(maxWidth: .infinity, alignment: .leading)
                    Text("Reps").frame(width: 50, alignment: .trailing)
                }
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 4)

                VStack(spacing: 6) {
                    ForEach(Array(exercise.sets.enumerated()), id: \.1.id) { idx, set in
                        HStack {
                            Text("\(idx + 1)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.35))
                                .frame(width: 28, alignment: .leading)
                            HStack(alignment: .lastTextBaseline, spacing: 2) {
                                Text(String(format: "%.1f", set.weightKg))
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("kg")
                                    .font(AppFont.caption)
                                    .foregroundColor(.white.opacity(0.35))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(set.reps)")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.currentday)
                            + Text(" reps")
                                .font(AppFont.caption)
                                .foregroundColor(.white.opacity(0.35))
                        }
                        .frame(width: nil)
                        .padding(.horizontal, 14)
                    }
                }
                .padding(.bottom, 12)
            }
        }
        .background(Color.backbutton)
        .cornerRadius(16)
    }
}
