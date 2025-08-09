//
//  Settings.swift
//  GymBro
//
//  Created by macbook on 27/07/2025.
//
import Foundation

enum SettingsKeys{
    
    static let darkMode = "isDarkMode"
    static let notificationEnabled = "isNotificationEnabled"
    static let weightUnit = "weightUnit"
}

enum WeightUnit: String, CaseIterable{
    case kg = "kg"
    case lbs = "lbs"
    
    var displayName: String{
        switch self {
        case .kg: return "kg"
        case .lbs: return "lbs"
        }
    }
}
