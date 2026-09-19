//
//  GoalsView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//
import SwiftUI

struct GoalsView: View {
    @EnvironmentObject var profileVM: OnboardingViewModel
    @EnvironmentObject var foodVM: FoodTrackerViewModel

    @AppStorage("goal_workouts_per_week") private var workoutsPerWeek: Int = 4
    @AppStorage("goal_target_weight")     private var targetWeight: Double = 75.0

    @AppStorage(FoodTrackerViewModel.goalModeKey)      private var goalModeRaw: String = NutritionGoalMode.maintain.rawValue
    @AppStorage(FoodTrackerViewModel.customCaloriesKey) private var customCalories: Int = 2000
    @AppStorage(FoodTrackerViewModel.customProteinKey)  private var customProtein: Double = 150
    @AppStorage(FoodTrackerViewModel.customFatKey)      private var customFat: Double = 60
    @AppStorage(FoodTrackerViewModel.customCarbsKey)    private var customCarbs: Double = 200

    private var selectedMode: NutritionGoalMode {
        NutritionGoalMode(rawValue: goalModeRaw) ?? .maintain
    }

    private var estimatedTargets: NutritionTargets? {
        NutritionCalculator.targets(for: profileVM.userProfile, mode: selectedMode)
    }

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    summaryBanner
                    trainingCard
                    nutritionGoalCard
                }
                .padding(16)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("My Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .task { try? await profileVM.fetchUserProfile() }
        .onChange(of: goalModeRaw)      { _, _ in foodVM.updateTargets(from: profileVM.userProfile) }
        .onChange(of: customCalories)   { _, _ in foodVM.updateTargets(from: profileVM.userProfile) }
        .onChange(of: customProtein)    { _, _ in foodVM.updateTargets(from: profileVM.userProfile) }
        .onChange(of: customFat)        { _, _ in foodVM.updateTargets(from: profileVM.userProfile) }
        .onChange(of: customCarbs)      { _, _ in foodVM.updateTargets(from: profileVM.userProfile) }
    }

    // MARK: - Summary Banner

    private var summaryBanner: some View {
        HStack(spacing: 0) {
            bannerStat(value: "\(workoutsPerWeek)×", label: "/ week")
            separator
            bannerStat(value: String(format: "%.0f", targetWeight), label: "kg target")
            separator
            bannerStat(value: "\(customCalories)", label: "kcal / day")
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private var separator: some View {
        Rectangle().fill(Color.weekDay.opacity(0.2)).frame(width: 1, height: 36)
    }

    private func bannerStat(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.body).foregroundColor(.currentday)
            Text(label).font(AppFont.caption).foregroundColor(.weekDay)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Training Card

    private var trainingCard: some View {
        VStack(spacing: 0) {
            cardHeader(title: "Training", icon: "dumbbell.fill", color: .currentday)
            Divider().background(Color.white.opacity(0.06))

            VStack(spacing: 0) {
                IntFieldRow(label: "Workouts / Week", unit: "days",
                            value: $workoutsPerWeek, range: 1...7)
                Divider().background(Color.white.opacity(0.06))
                DoubleFieldRow(label: "Target Weight", unit: "kg",
                               value: $targetWeight, range: 30...200, step: 0.5, fractionDigits: 1)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Nutrition Goal Card

    private var nutritionGoalCard: some View {
        VStack(spacing: 0) {
            cardHeader(title: "Nutrition Goal", icon: "flame.fill", color: .orange)
            Divider().background(Color.white.opacity(0.06))

            VStack(alignment: .leading, spacing: 12) {
                Text("Select your goal")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
                goalModePicker
            }
            .padding(16)

            if selectedMode != .custom {
                Divider().background(Color.white.opacity(0.06))
                if let t = estimatedTargets {
                    estimatedTargetsView(targets: t)
                } else {
                    noProfileHint
                }
            } else {
                Divider().background(Color.white.opacity(0.06))
                customNutritionInputs
            }
        }
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private var goalModePicker: some View {
        HStack(spacing: 8) {
            ForEach(NutritionGoalMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { goalModeRaw = mode.rawValue }
                } label: {
                    Text(mode.displayName)
                        .font(.system(size: 13, weight: selectedMode == mode ? .semibold : .regular))
                        .foregroundColor(selectedMode == mode ? .black : .white.opacity(0.5))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedMode == mode ? Color.currentday : Color.white.opacity(0.06))
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func estimatedTargetsView(targets: NutritionTargets) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Estimated targets")
                    .font(AppFont.caption).foregroundColor(.white.opacity(0.4))
                Spacer()
                Text(selectedMode.subtitle)
                    .font(AppFont.caption).foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            HStack(spacing: 0) {
                macroChip("\(targets.calories)", unit: "kcal", label: "Calories", color: .currentday)
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                macroChip(String(format: "%.0f", targets.protein), unit: "g", label: "Protein", color: Color(hex: "34D399"))
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                macroChip(String(format: "%.0f", targets.fat), unit: "g", label: "Fat", color: Color(hex: "FB923C"))
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                macroChip(String(format: "%.0f", targets.carbs), unit: "g", label: "Carbs", color: Color(hex: "A78BFA"))
            }
            .padding(.vertical, 10)
            .padding(.bottom, 4)
        }
    }

    private func macroChip(_ value: String, unit: String, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text(value).font(AppFont.subheadline).foregroundColor(color)
                Text(unit).font(AppFont.caption).foregroundColor(color.opacity(0.6))
            }
            Text(label).font(AppFont.caption).foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    private var noProfileHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .foregroundColor(.white.opacity(0.3))
            Text("Fill in your profile to get estimates")
                .font(AppFont.caption).foregroundColor(.white.opacity(0.4))
        }
        .padding(16)
    }

    private var customNutritionInputs: some View {
        VStack(spacing: 0) {
            Text("Set your own daily targets")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            VStack(spacing: 0) {
                IntFieldRow(label: "Calories", unit: "kcal",
                            value: $customCalories, range: 500...6000, step: 50)
                Divider().background(Color.white.opacity(0.06))
                DoubleFieldRow(label: "Protein", unit: "g",
                               value: $customProtein, range: 0...400, step: 5, fractionDigits: 0)
                Divider().background(Color.white.opacity(0.06))
                DoubleFieldRow(label: "Fat", unit: "g",
                               value: $customFat, range: 0...300, step: 5, fractionDigits: 0)
                Divider().background(Color.white.opacity(0.06))
                DoubleFieldRow(label: "Carbs", unit: "g",
                               value: $customCarbs, range: 0...600, step: 5, fractionDigits: 0)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 4)
        }
    }

    // MARK: - Helpers

    private func cardHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
            Text(title).font(AppFont.body).foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
