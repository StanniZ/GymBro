//
//  Gender.swift
//  GymBro
//
//  Created by macbook on 27/08/2025.
//
import Foundation

enum Gender: String, Codable, CaseIterable {
    case male, female, uknown
    
    init(databaseString: String?) {
        self = Gender(rawValue: databaseString ?? "") ?? .uknown
    }
}

extension Gender {
    var displayName: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .uknown:
            return "Unknown"
        }
    }
}

extension Gender {
    var displaySymbol: String {
        switch self {
        case .male:
            return "♂"
        case .female:
            return "♀"
        case .uknown:
            return "?"
        }
    }
}
