import Foundation
import SwiftUI

@MainActor
final class FoodTrackerViewModel: ObservableObject {

    @Published var meals: [MealSection] = []
    @Published var targets: NutritionTargets?

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private var todayKey: String { dateKey(for: Date()) }

    init() {
        loadTodayLog()
    }

    // MARK: - Totals

    var totalCalories: Int    { meals.reduce(0) { $0 + $1.totalCalories } }
    var totalProtein: Double  { meals.reduce(0) { $0 + $1.totalProtein } }
    var totalFat: Double      { meals.reduce(0) { $0 + $1.totalFat } }
    var totalCarbs: Double    { meals.reduce(0) { $0 + $1.totalCarbs } }

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
        targets = NutritionCalculator.targets(for: profile)
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

    // MARK: - Helpers

    private func dateKey(for date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: date)
    }

    private func storageKey(_ dateKey: String) -> String {
        "gymbro_food_log_\(dateKey)"
    }
}
