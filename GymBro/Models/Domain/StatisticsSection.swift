
//
//  StatisticsSection.swift
//  GymBro
//
//  Created by macbook on 09/01/2026.
//

enum StatisticsSection: CaseIterable {
    case history
    case exercise
    case nutrition

    var title: String {
        switch self {
        case .history:   return "History"
        case .exercise:  return "Exercise"
        case .nutrition: return "Nutrition"
        }
    }
}
