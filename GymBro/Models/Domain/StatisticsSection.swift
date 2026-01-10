
//
//  StatisticsSection.swift
//  GymBro
//
//  Created by macbook on 09/01/2026.
//

enum StatisticsSection: CaseIterable {
    case history
    case exercise
    case body
    
    var title: String {
        switch self {
        case .history: return "History"
        case .exercise: return "Exercise"
        case .body: return "Body"
        }
    }
}
