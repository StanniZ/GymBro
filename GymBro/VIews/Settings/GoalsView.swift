//
//  GoalsView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//
import SwiftUI

struct GoalsView: View {
    @AppStorage("goal_workouts_per_week") private var workoutsPerWeek: Int = 4
    @AppStorage("goal_target_weight")     private var targetWeight: Double = 75.0
    @AppStorage("goal_daily_calories")    private var dailyCalories: Int = 2000

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    summaryBanner
                    goalsCard
                }
                .padding(16)
            }
        }
        .navigationTitle("My Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Summary banner

    private var summaryBanner: some View {
        HStack(spacing: 0) {
            goalStat(value: "\(workoutsPerWeek)x", label: "/ week")
            Spacer()
            Rectangle().fill(Color.weekDay.opacity(0.2)).frame(width: 1, height: 40)
            Spacer()
            goalStat(value: String(format: "%.0f", targetWeight), label: "kg target")
            Spacer()
            Rectangle().fill(Color.weekDay.opacity(0.2)).frame(width: 1, height: 40)
            Spacer()
            goalStat(value: "\(dailyCalories)", label: "kcal / day")
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private func goalStat(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(AppFont.body)
                .foregroundColor(.currentday)
            Text(label)
                .font(AppFont.caption)
                .foregroundColor(.weekDay)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Editable rows

    private var goalsCard: some View {
        VStack(spacing: 0) {
            goalRow(
                icon: "dumbbell.fill",
                iconColor: .currentday,
                title: "Workouts / Week"
            ) {
                HStack(spacing: 10) {
                    Text("\(workoutsPerWeek) days")
                        .foregroundColor(.currentday)
                        .font(AppFont.subheadline)
                    Stepper("", value: $workoutsPerWeek, in: 1...7)
                        .labelsHidden()
                }
            }
            HorizontalDottedLineFull().padding(.leading, 50)

            goalRow(
                icon: "scalemass.fill",
                iconColor: .orange,
                title: "Target Weight"
            ) {
                HStack(spacing: 10) {
                    Text(String(format: "%.0f kg", targetWeight))
                        .foregroundColor(.currentday)
                        .font(AppFont.subheadline)
                    Stepper("", value: $targetWeight, in: 30...200, step: 0.5)
                        .labelsHidden()
                }
            }
            HorizontalDottedLineFull().padding(.leading, 50)

            goalRow(
                icon: "flame.fill",
                iconColor: .red,
                title: "Daily Calories"
            ) {
                HStack(spacing: 10) {
                    Text("\(dailyCalories) kcal")
                        .foregroundColor(.currentday)
                        .font(AppFont.subheadline)
                    Stepper("", value: $dailyCalories, in: 1000...5000, step: 50)
                        .labelsHidden()
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private func goalRow<Content: View>(
        icon: String,
        iconColor: Color,
        title: String,
        @ViewBuilder accessory: () -> Content
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            Text(title)
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            accessory()
        }
        .padding(.vertical, 12)
    }
}
