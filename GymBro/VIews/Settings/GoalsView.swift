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

    // Workout goals
    @AppStorage("goal_workouts_per_week") private var workoutsPerWeek: Int = 4
    @AppStorage("goal_target_weight")     private var targetWeight: Double = 75.0

    // Nutrition goal mode
    @AppStorage(FoodTrackerViewModel.goalModeKey) private var goalModeRaw: String = NutritionGoalMode.maintain.rawValue

    // Custom nutrition
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
                    workoutGoalsCard
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
        .onChange(of: goalModeRaw) { _ in
            foodVM.updateTargets(from: profileVM.userProfile)
        }
        .onChange(of: customCalories) { _ in
            foodVM.updateTargets(from: profileVM.userProfile)
        }
        .onChange(of: customProtein) { _ in
            foodVM.updateTargets(from: profileVM.userProfile)
        }
        .onChange(of: customFat) { _ in
            foodVM.updateTargets(from: profileVM.userProfile)
        }
        .onChange(of: customCarbs) { _ in
            foodVM.updateTargets(from: profileVM.userProfile)
        }
    }

    // MARK: - Summary Banner

    private var summaryBanner: some View {
        HStack(spacing: 0) {
            goalStat(value: "\(workoutsPerWeek)×", label: "/ week")
            Spacer()
            Rectangle().fill(Color.weekDay.opacity(0.2)).frame(width: 1, height: 40)
            Spacer()
            goalStat(value: String(format: "%.0f", targetWeight), label: "kg target")
            Spacer()
            Rectangle().fill(Color.weekDay.opacity(0.2)).frame(width: 1, height: 40)
            Spacer()
            goalStat(value: "\(customCalories)", label: "kcal / day")
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private func goalStat(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.body).foregroundColor(.currentday)
            Text(label).font(AppFont.caption).foregroundColor(.weekDay)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Workout Goals Card

    private var workoutGoalsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Training", icon: "dumbbell.fill", color: .currentday)
            Divider().background(Color.white.opacity(0.06))

            goalRow(icon: "dumbbell.fill", iconColor: .currentday, title: "Workouts / Week") {
                HStack(spacing: 8) {
                    Text("\(workoutsPerWeek) days")
                        .foregroundColor(.currentday).font(AppFont.subheadline)
                    Stepper("", value: $workoutsPerWeek, in: 1...7).labelsHidden()
                }
            }
            Divider().background(Color.white.opacity(0.06)).padding(.leading, 50)

            goalRow(icon: "scalemass.fill", iconColor: .orange, title: "Target Weight") {
                HStack(spacing: 8) {
                    Text(String(format: "%.0f kg", targetWeight))
                        .foregroundColor(.currentday).font(AppFont.subheadline)
                    Stepper("", value: $targetWeight, in: 30...200, step: 0.5).labelsHidden()
                }
            }
        }
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Nutrition Goal Card

    private var nutritionGoalCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader(title: "Nutrition Goal", icon: "flame.fill", color: .orange)
            Divider().background(Color.white.opacity(0.06))

            // Mode picker
            VStack(alignment: .leading, spacing: 12) {
                Text("Select your goal")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.top, 4)

                goalModePicker
            }
            .padding(16)

            // Estimated targets or custom inputs
            if selectedMode != .custom {
                if let t = estimatedTargets {
                    Divider().background(Color.white.opacity(0.06))
                    estimatedTargetsView(targets: t)
                } else {
                    Divider().background(Color.white.opacity(0.06))
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

    // MARK: - Mode Picker

    private var goalModePicker: some View {
        HStack(spacing: 8) {
            ForEach(NutritionGoalMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { goalModeRaw = mode.rawValue }
                } label: {
                    VStack(spacing: 4) {
                        Text(mode.displayName)
                            .font(.system(size: 13, weight: selectedMode == mode ? .semibold : .regular))
                            .foregroundColor(selectedMode == mode ? .black : .white.opacity(0.5))
                    }
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

    // MARK: - Estimated Targets

    private func estimatedTargetsView(targets: NutritionTargets) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Estimated targets")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
                Text(selectedMode.subtitle)
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            HStack(spacing: 0) {
                macroTarget(value: "\(targets.calories)", unit: "kcal", label: "Calories", color: .currentday)
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                macroTarget(value: String(format: "%.0fg", targets.protein), unit: "", label: "Protein", color: Color(hex: "34D399"))
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                macroTarget(value: String(format: "%.0fg", targets.fat), unit: "", label: "Fat", color: Color(hex: "FB923C"))
                Rectangle().fill(Color.white.opacity(0.08)).frame(width: 1, height: 36)
                macroTarget(value: String(format: "%.0fg", targets.carbs), unit: "", label: "Carbs", color: Color(hex: "A78BFA"))
            }
            .padding(.vertical, 12)
            .padding(.bottom, 4)
        }
    }

    private func macroTarget(value: String, unit: String, label: String, color: Color) -> some View {
        VStack(spacing: 3) {
            Text(value + unit)
                .font(AppFont.subheadline)
                .foregroundColor(color)
            Text(label)
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    private var noProfileHint: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .foregroundColor(.white.opacity(0.3))
            Text("Fill in your profile to get estimates")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(16)
    }

    // MARK: - Custom Nutrition Inputs

    private var customNutritionInputs: some View {
        VStack(spacing: 0) {
            Text("Set your own targets")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            customRow(icon: "flame.fill", iconColor: .currentday, title: "Calories (kcal)") {
                HStack(spacing: 8) {
                    Text("\(customCalories)")
                        .foregroundColor(.currentday).font(AppFont.subheadline)
                    Stepper("", value: $customCalories, in: 500...6000, step: 50).labelsHidden()
                }
            }
            Divider().background(Color.white.opacity(0.06)).padding(.leading, 50)

            customRow(icon: "p.circle.fill", iconColor: Color(hex: "34D399"), title: "Protein (g)") {
                HStack(spacing: 8) {
                    Text("\(Int(customProtein))g")
                        .foregroundColor(Color(hex: "34D399")).font(AppFont.subheadline)
                    Stepper("", value: $customProtein, in: 0...400, step: 5).labelsHidden()
                }
            }
            Divider().background(Color.white.opacity(0.06)).padding(.leading, 50)

            customRow(icon: "f.circle.fill", iconColor: Color(hex: "FB923C"), title: "Fat (g)") {
                HStack(spacing: 8) {
                    Text("\(Int(customFat))g")
                        .foregroundColor(Color(hex: "FB923C")).font(AppFont.subheadline)
                    Stepper("", value: $customFat, in: 0...300, step: 5).labelsHidden()
                }
            }
            Divider().background(Color.white.opacity(0.06)).padding(.leading, 50)

            customRow(icon: "c.circle.fill", iconColor: Color(hex: "A78BFA"), title: "Carbs (g)") {
                HStack(spacing: 8) {
                    Text("\(Int(customCarbs))g")
                        .foregroundColor(Color(hex: "A78BFA")).font(AppFont.subheadline)
                    Stepper("", value: $customCarbs, in: 0...600, step: 5).labelsHidden()
                }
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
            Text(title)
                .font(AppFont.body)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func goalRow<Content: View>(icon: String, iconColor: Color, title: String, @ViewBuilder accessory: () -> Content) -> some View {
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func customRow<Content: View>(icon: String, iconColor: Color, title: String, @ViewBuilder accessory: () -> Content) -> some View {
        goalRow(icon: icon, iconColor: iconColor, title: title, accessory: accessory)
    }
}
