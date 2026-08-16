import Foundation

struct FoodEntry: Identifiable, Codable {
    let id: UUID
    var name: String
    var calories: Int
    var protein: Double
    var fat: Double
    var carbs: Double

    init(id: UUID = UUID(), name: String, calories: Int,
         protein: Double = 0, fat: Double = 0, carbs: Double = 0) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbs = carbs
    }
}

struct MealSection: Identifiable, Codable {
    let id: UUID
    var title: String
    var entries: [FoodEntry]

    init(id: UUID = UUID(), title: String, entries: [FoodEntry] = []) {
        self.id = id
        self.title = title
        self.entries = entries
    }

    var totalCalories: Int    { entries.reduce(0) { $0 + $1.calories } }
    var totalProtein: Double  { entries.reduce(0) { $0 + $1.protein } }
    var totalFat: Double      { entries.reduce(0) { $0 + $1.fat } }
    var totalCarbs: Double    { entries.reduce(0) { $0 + $1.carbs } }
}

struct NutritionTargets {
    let calories: Int
    let protein: Double
    let fat: Double
    let carbs: Double
}

struct DailyNutritionLog: Codable {
    var date: String   // "yyyy-MM-dd"
    var meals: [MealSection]
}

// MARK: - TDEE Calculator (Mifflin-St Jeor)
enum NutritionCalculator {
    static func targets(for profile: UserProfile) -> NutritionTargets? {
        guard profile.weight > 0, profile.height > 0, profile.age > 0 else { return nil }
        let w = profile.weight
        let h = Double(profile.height)
        let a = Double(profile.age)

        let bmr: Double
        switch profile.gender {
        case .male:
            bmr = 10 * w + 6.25 * h - 5 * a + 5
        case .female:
            bmr = 10 * w + 6.25 * h - 5 * a - 161
        case .uknown:
            bmr = 10 * w + 6.25 * h - 5 * a - 78
        }

        let tdee = bmr * 1.55  // moderate activity (gym user)
        return NutritionTargets(
            calories: Int(tdee.rounded()),
            protein: (tdee * 0.30) / 4.0,
            fat:     (tdee * 0.25) / 9.0,
            carbs:   (tdee * 0.45) / 4.0
        )
    }
}
