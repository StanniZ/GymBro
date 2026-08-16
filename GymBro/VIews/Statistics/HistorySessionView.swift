//
//  HistorySessionView.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct HistorySessionView: View {
    @EnvironmentObject var viewModel: HistorySessionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.sessions.isEmpty {
                emptyState
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.sessions) { session in
                        CellHistorySession(session: session) { id in
                            withAnimation {
                                viewModel.deleteSession(id: id)
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.98)),
                            removal:   .opacity
                        ))
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 44))
                .foregroundColor(.white.opacity(0.2))
            VStack(spacing: 6) {
                Text("No sessions yet")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                Text("Finish a workout to see it here")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(Color.backbutton)
        .cornerRadius(20)
    }
}

struct CellHistorySession: View {
    let session: TrainingSessionModel
    let onDelete: (UUID) -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: DetailsSessionView(session: session)) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.name)
                                .font(AppFont.body)
                                .foregroundColor(.white)
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
                        Spacer()
                        Color.clear.frame(width: 32, height: 32)
                    }

                    Divider().background(Color.white.opacity(0.06))

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
            .buttonStyle(.plain)

            Button {
                onDelete(session.id)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.4))
                    .frame(width: 28, height: 28)
                    .background(Color.white.opacity(0.07))
                    .cornerRadius(8)
            }
            .padding(12)
        }
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
}

extension Date {
    var dateForSessionHistory: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}
