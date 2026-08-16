import Foundation
import SwiftUI

@MainActor
final class FoodTrackerViewModel: ObservableObject {

    @Published var meals: [MealSection] = []
    @Published var targets: NutritionTargets?

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var todayKey: String { dateKey(for: Date()) }

    // UserDefaults keys
    static let goalModeKey      = "gymbro_nutrition_goal_mode"
    static let customCaloriesKey = "goal_daily_calories"
    static let customProteinKey  = "gymbro_custom_protein_g"
    static let customFatKey      = "gymbro_custom_fat_g"
    static let customCarbsKey    = "gymbro_custom_carbs_g"

    init() {
        loadTodayLog()
    }

    // MARK: - Totals

    var totalCalories: Int    { meals.reduce(0) { $0 + $1.totalCalories } }
    var totalProtein:  Double { meals.reduce(0) { $0 + $1.totalProtein } }
    var totalFat:      Double { meals.reduce(0) { $0 + $1.totalFat } }
    var totalCarbs:    Double { meals.reduce(0) { $0 + $1.totalCarbs } }

    var caloriesProgress: Double {
        guard let t = targets, t.calories > 0 else { return 0 }
        return min(1.0, Double(totalCalories) / Double(t.calories))
    }
    var proteinProgress: Double {
        guard let t = targets, t.protein > 0 else { return 0 }
        return min(1.0, totalProtein / t.protein)
    }
    var fatProgress: Double {
        guard let t = targets, t.fat > 0 else { return 0 }
        return min(1.0, totalFat / t.fat)
    }
    var carbsProgress: Double {
        guard let t = targets, t.carbs > 0 else { return 0 }
        return min(1.0, totalCarbs / t.carbs)
    }

    // MARK: - Targets

    func updateTargets(from profile: UserProfile) {
        let modeRaw = UserDefaults.standard.string(forKey: Self.goalModeKey) ?? ""
        let mode = NutritionGoalMode(rawValue: modeRaw) ?? .maintain

        if mode == .custom {
            targets = customTargets()
        } else {
            targets = NutritionCalculator.targets(for: profile, mode: mode)
        }
    }

    private func customTargets() -> NutritionTargets? {
        let kcal = UserDefaults.standard.integer(forKey: Self.customCaloriesKey)
        guard kcal > 0 else { return nil }
        let protein = UserDefaults.standard.double(forKey: Self.customProteinKey)
        let fat     = UserDefaults.standard.double(forKey: Self.customFatKey)
        let carbs   = UserDefaults.standard.double(forKey: Self.customCarbsKey)
        let kd = Double(kcal)
        return NutritionTargets(
            calories: kcal,
            protein:  protein > 0 ? protein : kd * 0.30 / 4,
            fat:      fat     > 0 ? fat     : kd * 0.25 / 9,
            carbs:    carbs   > 0 ? carbs   : kd * 0.45 / 4
        )
    }

    // MARK: - Meal CRUD

    func addMealSection(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        meals.append(MealSection(title: title))
        save()
    }

    func deleteMealSection(id: UUID) {
        meals.removeAll { $0.id == id }
        save()
    }

    func addEntry(_ entry: FoodEntry, to mealID: UUID) {
        guard let idx = meals.firstIndex(where: { $0.id == mealID }) else { return }
        meals[idx].entries.append(entry)
        save()
    }

    func deleteEntry(entryID: UUID, from mealID: UUID) {
        guard let idx = meals.firstIndex(where: { $0.id == mealID }) else { return }
        meals[idx].entries.removeAll { $0.id == entryID }
        save()
    }

    // MARK: - Persistence

    private func loadTodayLog() {
        let key = storageKey(todayKey)
        if let data = UserDefaults.standard.data(forKey: key),
           let log = try? decoder.decode(DailyNutritionLog.self, from: data) {
            meals = log.meals
        } else {
            meals = [
                MealSection(title: "Breakfast"),
                MealSection(title: "Lunch"),
                MealSection(title: "Dinner"),
                MealSection(title: "Snack")
            ]
            save()
        }
    }

    func save() {
        let key = storageKey(todayKey)
        let log = DailyNutritionLog(date: todayKey, meals: meals)
        if let data = try? encoder.encode(log) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // Statistics: read any day's log
    func log(for date: Date) -> DailyNutritionLog? {
        let key = storageKey(dateKey(for: date))
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? decoder.decode(DailyNutritionLog.self, from: data)
    }

    // Return last N days (newest first) that have data
    func recentLogs(days: Int = 7) -> [(date: Date, log: DailyNutritionLog)] {
        var result: [(Date, DailyNutritionLog)] = []
        let cal = Calendar.current
        for offset in 0..<days {
            if let date = cal.date(byAdding: .day, value: -offset, to: Date()),
               let l = log(for: date) {
                result.append((date, l))
            }
        }
        return result
    }

    // MARK: - Helpers

    func dateKey(for date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }

    private func storageKey(_ dateKey: String) -> String {
        "gymbro_food_log_\(dateKey)"
    }
}
