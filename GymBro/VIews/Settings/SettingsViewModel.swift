//
//  SettingsViewModel.swift
//  GymBro
//
//  Created by macbook on 27/07/2025.
//
import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @AppStorage("notifications_enabled")
    var isNotificationsEnabled: Bool = false
    
    @AppStorage("dark_mode_enabled")
    var isDarkModeEnabled: Bool = true
    
    @AppStorage("weightUnit")
    private var WeightUnitRaw: String = WeightUnit.kg.rawValue

    var weightUnit: WeightUnit {
        get { WeightUnit(rawValue: WeightUnitRaw) ?? .kg }
        set { WeightUnitRaw = newValue.rawValue }
    }
    
    
    func logout() {
        
        print("Logout")
    }
    
}
