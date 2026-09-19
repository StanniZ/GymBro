import Foundation

struct FoodEntry: Identifiable, Codable {
    let id: UUID
    var name: String
    var amountGrams: Double?
    var calories: Int
    var protein: Double
    var fat: Double
    var carbs: Double

    init(id: UUID = UUID(), name: String, calories: Int,
         amountGrams: Double? = nil,
         protein: Double = 0, fat: Double = 0, carbs: Double = 0) {
        self.id = id
        self.name = name
        self.amountGrams = amountGrams
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

// MARK: - Nutrition Goal Mode

enum NutritionGoalMode: String, CaseIterable {
    case maintain = "maintain"
    case bulk     = "bulk"
    case cut      = "cut"
    case custom   = "custom"

    var displayName: String {
        switch self {
        case .maintain: return "Maintain"
        case .bulk:     return "Bulk"
        case .cut:      return "Cut"
        case .custom:   return "Custom"
        }
    }

    var subtitle: String {
        switch self {
        case .maintain: return "Keep current weight"
        case .bulk:     return "Gain muscle (+15% cal)"
        case .cut:      return "Lose fat (−20% cal)"
        case .custom:   return "Set your own targets"
        }
    }

    var calorieMultiplier: Double {
        switch self {
        case .maintain: return 1.00
        case .bulk:     return 1.15
        case .cut:      return 0.80
        case .custom:   return 1.00
        }
    }

    var proteinFraction: Double {
        switch self {
        case .maintain: return 0.30
        case .bulk:     return 0.35
        case .cut:      return 0.40
        case .custom:   return 0.30
        }
    }

    var fatFraction: Double { 0.25 }

    var carbsFraction: Double {
        switch self {
        case .maintain: return 0.45
        case .bulk:     return 0.40
        case .cut:      return 0.35
        case .custom:   return 0.45
        }
    }
}

// MARK: - TDEE Calculator (Mifflin-St Jeor)

enum NutritionCalculator {
    static func targets(for profile: UserProfile,
                        mode: NutritionGoalMode = .maintain) -> NutritionTargets? {
        guard profile.weight > 0, profile.height > 0, profile.age > 0 else { return nil }
        let w = profile.weight
        let h = Double(profile.height)
        let a = Double(profile.age)

        let bmr: Double
        switch profile.gender {
        case .male:   bmr = 10 * w + 6.25 * h - 5 * a + 5
        case .female: bmr = 10 * w + 6.25 * h - 5 * a - 161
        case .uknown: bmr = 10 * w + 6.25 * h - 5 * a - 78
        }

        let tdee = bmr * 1.55
        let calories = tdee * mode.calorieMultiplier

        return NutritionTargets(
            calories: Int(calories.rounded()),
            protein:  (calories * mode.proteinFraction) / 4.0,
            fat:      (calories * mode.fatFraction)     / 9.0,
            carbs:    (calories * mode.carbsFraction)   / 4.0
        )
    }
}
