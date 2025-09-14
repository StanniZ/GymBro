//
//  Statistics.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct HistorySession: View {
    @StateObject var viewModel: StatisticsViewModel
    
    init(provider: StatisticsProtocol) {
            _viewModel = StateObject(wrappedValue: StatisticsViewModel(provider: provider))
        }
    
    private var sessions: [TrainingSessionModel] {
        viewModel.sessions
    }
    
    var body: some View {
        VStack(spacing: 16) {
            header
            scrollHistory
            Spacer()
        }
        .task {
            await viewModel.load()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(16)
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
            LazyVStack(spacing: 8) {
                ForEach(sessions) { session in
                    CellHistorySession(session: session)
                }
            }
        }
    }
    
}

struct CellHistorySession: View {
    let session: TrainingSessionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            nameSession
            dateSession
            HorizontalDottedLineFull()
            infoSession
        }
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    private var nameSession: some View {
        Text(session.muscleName)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.white)
    }
    
    private var dateSession: some View {
        HStack(spacing: 8){
            Image(systemName: "calendar")
                .foregroundColor(.white.opacity(0.5))
            if let timestamp = session.timestamp {
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
