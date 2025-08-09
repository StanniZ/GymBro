//
//  GymBroApp.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//

import SwiftUI

@main
struct GymBroApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var currentSessionProvider = CurrentSessionProvider()
    @StateObject private var appState = AppState()
    @StateObject private var settings = SettingsViewModel()
    
    init(){
        CoreDataSeeder.shared.seedInitialSessionIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(currentSessionProvider)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
