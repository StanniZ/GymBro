//
//  SettingsConfiguration.swift
//  GymBro
//
//  Created by macbook on 01/02/2026.
//
import SwiftUI

struct SettingsConfiguration {

    let sections: [Section]

    struct Section: Identifiable {
        let id: UUID = UUID()
        let header: String
        let items: [Item]
    }

    enum Item: Identifiable {
        case navigation(id: UUID = UUID(), NavigationItem)
        case toggle(id: UUID = UUID(), ToggleItem)

        var id: UUID {
            switch self {
            case .navigation(let id, _), .toggle(id: let id, _):
                return id
            }
        }
    }

    struct NavigationItem {
        let title: String
        let icon: String
        let iconColor: IconColor
        let destination: SettingsDestination

        init(title: String, icon: String, iconColor: IconColor = .accent, destination: SettingsDestination) {
            self.title = title
            self.icon = icon
            self.iconColor = iconColor
            self.destination = destination
        }
    }

    struct ToggleItem {
        let title: String
        let icon: String
        let iconColor: IconColor
        let key: ToggleKey

        init(title: String, icon: String, iconColor: IconColor = .accent, key: ToggleKey) {
            self.title = title
            self.icon = icon
            self.iconColor = iconColor
            self.key = key
        }
    }

    enum IconColor {
        case accent, red, purple, blue, orange, green, teal

        var solidColor: Color {
            switch self {
            case .accent:  return .currentday
            case .red:     return .red
            case .purple:  return .purple
            case .blue:    return .blue
            case .orange:  return .orange
            case .green:   return .green
            case .teal:    return .teal
            }
        }
    }
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lb = "lbs"

    var displayName: String {
        rawValue
    }
}
