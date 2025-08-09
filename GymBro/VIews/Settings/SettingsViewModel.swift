//
//  SettingsViewModel.swift
//  GymBro
//
//  Created by macbook on 27/07/2025.
//
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @AppStorage(SettingsKeys.darkMode)
    var isDarkModeEnabled: Bool = true
    
    @AppStorage(SettingsKeys.notificationEnabled)
    var isNotificationEnabled: Bool = false
    
    @AppStorage(SettingsKeys.weightUnit)
    var weightUnit: WeightUnit = .kg
    
    
}
