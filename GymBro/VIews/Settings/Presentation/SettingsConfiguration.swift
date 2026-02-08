//
//  SettingsConfiguration.swift
//  GymBro
//
//  Created by macbook on 01/02/2026.
//
import Foundation

struct SettingsConfiguration {
    
    let sections: [Section]
    
    struct Section: Identifiable {
        let id: UUID = UUID()
        let items: [Item]
    }
    
    enum Item: Identifiable {
        case navigation(id: UUID = UUID(), NavigationItem)
        case toggle(id: UUID = UUID(), ToggleItem)
        
        var id: UUID {
            switch self {
            case .navigation(let id, _),
                    .toggle(id: let id, _):
                return id
            }
        }
    }
    
    struct NavigationItem {
            let title: String
            let icon: String
            let destination: SettingsDestination
        }

        struct ToggleItem {
            let title: String
            let icon: String
            let key: ToggleKey
        }
}

enum WeightUnit: String, CaseIterable{
    case kg = "kg"
    case lb = "lbs"
    
    var displayName: String{
        switch self {
        case .kg: return "kg"
        case .lb: return "lbs"
        }
    }
}
