//
//  CalorieEstimator.swift
//  GymBro
//
import Foundation

enum CalorieSource {
    case estimated
    case healthKit
}

struct CalorieEstimate {
    let calories: Int
    let source: CalorieSource
}

struct CalorieEstimator {
    // MET for traditional strength training, moderate effort
    private static let met: Double = 5.0

    /// Estimates active calories burned using the MET formula:
    /// kcal = MET × weight_kg × duration_hours
    static func estimate(
        durationSeconds: TimeInterval,
        weightKg: Double = 70.0
    ) -> CalorieEstimate {
        guard durationSeconds > 0 else {
            return CalorieEstimate(calories: 0, source: .estimated)
        }
        let hours = durationSeconds / 3600.0
        let weight = weightKg > 0 ? weightKg : 70.0
        let kcal = met * weight * hours
        return CalorieEstimate(calories: max(1, Int(kcal.rounded())), source: .estimated)
    }
}
