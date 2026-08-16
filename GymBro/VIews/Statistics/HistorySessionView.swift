//
//  Statistics.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct HistorySessionView: View {
    @EnvironmentObject var viewModel: HistorySessionViewModel
    
    private var sessions: [TrainingSessionModel] {
        viewModel.sessions
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            scrollHistory
            Spacer()
        }   
        .task {
            await viewModel.load()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.backmain)
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Session history")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(Color.white.opacity(0.5))
        }
    }
    
    private var scrollHistory: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(sessions) { session in
                    CellHistorySession(session: session, onDelete: { id in
                        withAnimation {
                            viewModel.deleteSession(id: id)
                        }
                    })
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98)),
                        removal:   .opacity
                    ))
                }
            }
        }
    }
    
}

struct CellHistorySession: View {
    let session: TrainingSessionModel
    let onDelete: (UUID) -> Void

    var body: some View {
        // ZStack: NavigationLink as background, delete button on top so it
        // intercepts its own taps without triggering navigation.
        ZStack(alignment: .topTrailing) {
            NavigationLink(destination: DetailsSessionView(session: session)) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        nameSession
                        Spacer()
                        // Transparent placeholder keeps the same height as the button
                        Color.clear.frame(width: 32, height: 32)
                    }
                    dateSession
                    HorizontalDottedLineFull()
                    infoSession
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                )
            }

            // Delete button sits above NavigationLink and captures its own taps
            Button {
                onDelete(session.id)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            .padding(12)
        }
    }

    private var nameSession: some View {
        Text(session.name)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.white)
    }
    
    private var dateSession: some View {
        HStack(spacing: 8){
            Image(systemName: "calendar")
                .foregroundColor(.white.opacity(0.5))
            if let timestamp = session.finishedAt {
                Text(timestamp.dateForSessionHistory)
            } else {
                Text("-")
            }
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(.white.opacity(0.7))
    }
    
    private var infoSession: some View {
        HStack {
            parameterSession(value: "1,076", title: "Total Weight")
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
            parameterSession(value: "\(session.durationMinutes)", title: "Duration")
            VerticalDottedLine(dotSize: 1, spacing: 2, height: 50)
            parameterSession(value: "\(session.calories)", title: "Calories")
        }
    }
    
    private func parameterSession(value: String, title: String) -> some View {
        VStack(alignment: .center ,spacing: 8){
            Text(value)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .center)
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
