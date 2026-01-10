//
//  StatisticsView.swift
//  GymBro
//
//  Created by macbook on 07/01/2026.
//
import SwiftUI

struct StatisticsView: View {
    @State private var section: StatisticsSection = .history
    
    var body: some View {
        VStack(spacing: 16) {
            TitleView()
            StatisticsSectionPicker(selection: $section)
            contentView
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(Color.backmain)
    }
    
    private struct TitleView: View {
        var body: some View {
            HStack {
                Text("Statistics")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(Color.white.opacity(0.6))
                Spacer()
            }
            .padding(.horizontal, 8)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch section {
        case .history:
            HistorySessionView()
        case .exercise:
            Text("Exercise")
        case .body:
            Text("body")
        }
    }
    
}

