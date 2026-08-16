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
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    StatisticsSectionPicker(selection: $section)
                    contentView
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(Color.backmain)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Statistics")
                    .font(AppFont.title)
                    .foregroundColor(.white)
                Text(formattedDate)
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch section {
        case .history:
            HistorySessionView()
        case .exercise:
            exerciseStub
        case .nutrition:
            NutritionStatisticsView()
        }
    }

    private var exerciseStub: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 44))
                .foregroundColor(.white.opacity(0.2))
            VStack(spacing: 6) {
                Text("Coming soon")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                Text("Exercise progress charts will appear here")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private var formattedDate: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, d MMMM"
        return df.string(from: Date())
    }
}
