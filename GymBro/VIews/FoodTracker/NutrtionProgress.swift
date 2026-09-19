import SwiftUI

struct NutritionProgressCard: View {
    @ObservedObject var vm: FoodTrackerViewModel

    private let arc: Double = 0.66
    private let lineWidth: CGFloat = 18

    private var remainingCalories: Int {
        max((vm.targets?.calories ?? 0) - vm.totalCalories, 0)
    }

    private var overCalories: Int {
        max(vm.totalCalories - (vm.targets?.calories ?? 0), 0)
    }

    private var calorieColor: Color {
        guard let target = vm.targets?.calories, target > 0 else { return .currentday }
        let ratio = Double(vm.totalCalories) / Double(target)
        if ratio > 1.0 { return .red }
        if ratio > 0.9 { return .yellow }
        return .currentday
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                ringBackground
                ringFill
                calorieLabel
            }
            .frame(width: 130, height: 130)
            .offset(y: 12)

            VStack(spacing: 14) {
                MacroRow(
                    title: "Carbs",
                    current: vm.totalCarbs,
                    target: vm.targets?.carbs ?? 0,
                    progress: vm.carbsProgress,
                    color: Color(hex: "A78BFA")
                )
                MacroRow(
                    title: "Protein",
                    current: vm.totalProtein,
                    target: vm.targets?.protein ?? 0,
                    progress: vm.proteinProgress,
                    color: Color(hex: "34D399")
                )
                MacroRow(
                    title: "Fat",
                    current: vm.totalFat,
                    target: vm.targets?.fat ?? 0,
                    progress: vm.fatProgress,
                    color: Color(hex: "FB923C")
                )
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private var ringBackground: some View {
        Circle()
            .trim(from: 0, to: arc)
            .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(90 + (1 - arc) * 180))
    }

    private var ringFill: some View {
        Circle()
            .trim(from: 0, to: arc * vm.caloriesProgress)
            .stroke(calorieColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .rotationEffect(.degrees(90 + (1 - arc) * 180))
            .animation(.easeOut(duration: 0.4), value: vm.caloriesProgress)
    }

    private var calorieLabel: some View {
        VStack(spacing: 2) {
            Text("\(vm.totalCalories)")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text("/ \(vm.targets?.calories ?? 0)")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
            Text("kcal")
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
            Text(overCalories > 0 ? "\(overCalories) over" : "\(remainingCalories) left")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(calorieColor)
        }
    }
}

private struct MacroRow: View {
    let title: String
    let current: Double
    let target: Double
    let progress: Double
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(title)
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Text(String(format: "%.0fg", current))
                    .font(AppFont.caption)
                    .foregroundColor(.white)
                Text(String(format: "/ %.0fg", target))
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
            }
            ProgressView(value: progress)
                .tint(color)
                .animation(.easeOut(duration: 0.4), value: progress)
        }
    }
}
