import SwiftUI

struct NutritionStatisticsView: View {
    @EnvironmentObject var foodVM: FoodTrackerViewModel

    private var recentLogs: [(date: Date, log: DailyNutritionLog)] {
        foodVM.recentLogs(days: 7)
    }

    private var weeklyAvgCalories: Int {
        guard !recentLogs.isEmpty else { return 0 }
        let total = recentLogs.reduce(0) { $0 + $1.log.meals.reduce(0) { $0 + $1.totalCalories } }
        return total / recentLogs.count
    }

    private var weeklyAvgProtein: Double {
        guard !recentLogs.isEmpty else { return 0 }
        let total = recentLogs.reduce(0.0) { $0 + $1.log.meals.reduce(0.0) { $0 + $1.totalProtein } }
        return total / Double(recentLogs.count)
    }

    private var weeklyAvgFat: Double {
        guard !recentLogs.isEmpty else { return 0 }
        let total = recentLogs.reduce(0.0) { $0 + $1.log.meals.reduce(0.0) { $0 + $1.totalFat } }
        return total / Double(recentLogs.count)
    }

    private var weeklyAvgCarbs: Double {
        guard !recentLogs.isEmpty else { return 0 }
        let total = recentLogs.reduce(0.0) { $0 + $1.log.meals.reduce(0.0) { $0 + $1.totalCarbs } }
        return total / Double(recentLogs.count)
    }

    var body: some View {
        if recentLogs.isEmpty {
            emptyState
        } else {
            VStack(spacing: 16) {
                weeklyAverageCard
                caloriesChartCard
                dailyLogsList
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 44))
                .foregroundColor(.white.opacity(0.2))
            VStack(spacing: 6) {
                Text("No nutrition data yet")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                Text("Start tracking meals in the Food tab")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.35))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Weekly Average Card

    private var weeklyAverageCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("7-Day Average")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(recentLogs.count) days tracked")
                    .font(AppFont.caption)
                    .foregroundColor(.white.opacity(0.4))
            }

            HStack(spacing: 0) {
                avgStat(value: "\(weeklyAvgCalories)", label: "kcal", color: .currentday)
                divider
                avgStat(value: String(format: "%.0fg", weeklyAvgProtein), label: "Protein", color: Color(hex: "34D399"))
                divider
                avgStat(value: String(format: "%.0fg", weeklyAvgFat), label: "Fat", color: Color(hex: "FB923C"))
                divider
                avgStat(value: String(format: "%.0fg", weeklyAvgCarbs), label: "Carbs", color: Color(hex: "A78BFA"))
            }
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.08))
            .frame(width: 1, height: 36)
    }

    private func avgStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppFont.body)
                .foregroundColor(color)
            Text(label)
                .font(AppFont.caption)
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Calories Chart Card

    private var caloriesChartCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Calories this week")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            CaloriesBarChart(logs: recentLogs, target: foodVM.targets?.calories ?? 0)
                .frame(height: 120)
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Daily Logs List

    private var dailyLogsList: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Daily breakdown")
                    .font(AppFont.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            ForEach(recentLogs, id: \.date) { item in
                DailyNutritionRow(date: item.date, log: item.log, target: foodVM.targets?.calories)
            }
        }
    }
}

// MARK: - Bar Chart

private struct CaloriesBarChart: View {
    let logs: [(date: Date, log: DailyNutritionLog)]
    let target: Int

    private let df: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }()

    var body: some View {
        GeometryReader { geo in
            let calories = logs.map { $0.log.meals.reduce(0) { $0 + $1.totalCalories } }
            let maxVal = max(target, calories.max() ?? 1, 1)
            let barW = (geo.size.width - CGFloat(logs.count - 1) * 6) / CGFloat(max(logs.count, 1))

            HStack(alignment: .bottom, spacing: 6) {
                ForEach(logs.indices, id: \.self) { i in
                    let kcal = calories[i]
                    let barH = geo.size.height * CGFloat(kcal) / CGFloat(maxVal)
                    let targetH = geo.size.height * CGFloat(target) / CGFloat(maxVal)
                    let overGoal = target > 0 && kcal > target

                    VStack(spacing: 4) {
                        Spacer(minLength: 0)

                        ZStack(alignment: .bottom) {
                            // Target reference bar (ghost)
                            if target > 0 {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.05))
                                    .frame(width: barW, height: max(targetH, 4))
                            }
                            // Actual bar
                            RoundedRectangle(cornerRadius: 4)
                                .fill(kcal == 0
                                    ? Color.white.opacity(0.06)
                                    : (overGoal ? Color.red.opacity(0.7) : Color.currentday))
                                .frame(width: barW, height: max(barH, kcal > 0 ? 4 : 2))
                        }

                        Text(df.string(from: logs[i].date))
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
            }
        }
    }
}

// MARK: - Daily Nutrition Row

private struct DailyNutritionRow: View {
    let date: Date
    let log: DailyNutritionLog
    let target: Int?
    @State private var expanded = false

    private var totalCalories: Int    { log.meals.reduce(0) { $0 + $1.totalCalories } }
    private var totalProtein: Double  { log.meals.reduce(0.0) { $0 + $1.totalProtein } }
    private var totalFat: Double      { log.meals.reduce(0.0) { $0 + $1.totalFat } }
    private var totalCarbs: Double    { log.meals.reduce(0.0) { $0 + $1.totalCarbs } }

    private var dateLabel: String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        let df = DateFormatter()
        df.dateFormat = "EEE, d MMM"
        return df.string(from: date)
    }

    private var progressColor: Color {
        guard let t = target, t > 0 else { return .currentday }
        let ratio = Double(totalCalories) / Double(t)
        if ratio > 1.1 { return .red.opacity(0.8) }
        if ratio > 0.9 { return .currentday }
        return .white.opacity(0.4)
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(dateLabel)
                            .font(AppFont.subheadline)
                            .foregroundColor(.white)
                        if let t = target, t > 0 {
                            Text("\(totalCalories) / \(t) kcal")
                                .font(AppFont.caption)
                                .foregroundColor(.white.opacity(0.4))
                        } else {
                            Text("\(totalCalories) kcal")
                                .font(AppFont.caption)
                                .foregroundColor(.white.opacity(0.4))
                        }
                    }

                    Spacer()

                    HStack(spacing: 12) {
                        Text("\(totalCalories)")
                            .font(AppFont.body)
                            .foregroundColor(progressColor)
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if expanded {
                Divider().background(Color.white.opacity(0.08))
                HStack(spacing: 0) {
                    macroCell(value: String(format: "%.0fg", totalProtein), label: "Protein", color: Color(hex: "34D399"))
                    Divider().background(Color.white.opacity(0.08)).frame(height: 36)
                    macroCell(value: String(format: "%.0fg", totalFat), label: "Fat", color: Color(hex: "FB923C"))
                    Divider().background(Color.white.opacity(0.08)).frame(height: 36)
                    macroCell(value: String(format: "%.0fg", totalCarbs), label: "Carbs", color: Color(hex: "A78BFA"))
                }
                .padding(.vertical, 12)
            }
        }
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private func macroCell(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(AppFont.subheadline).foregroundColor(color)
            Text(label).font(AppFont.caption).foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
}
