//
//  SettingsItemModel.swift
//  GymBro
//
//  Created by macbook on 28/07/2025.
//
import SwiftUI

struct SettingsItemModel: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
    var isShowsToggle: Bool
    var toggleValue: Binding<Bool>?
}
