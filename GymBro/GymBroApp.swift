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
    @StateObject private var todaySessionVM: TodaySessionViewModel
    @StateObject private var buildSessionVM: BuildSessionViewModel
    @StateObject private var calendarVM: CalendarViewModel
    @StateObject private var currentSessionProvider: CurrentSessionProvider
    @StateObject private var appState = AppState()
    @StateObject private var settings = SettingsViewModel()
    @StateObject private var history: HistorySessionViewModel
    @StateObject private var timerSession = SessionTimerViewModel()
    
    init(){
        let pc = PersistenceController.shared
        let current = CurrentSessionProvider()
        let context = PersistenceController.shared.container.viewContext
        let providerToday = CoreDataTodaysSessionProvider(context: pc.context, container: pc.container)
        let providerSession = CoreDataTrainingSessionProvider(context: context)
        
        CoreDataSeeder.shared.seedInitialSessionIfNeeded()
        
        _history = StateObject(wrappedValue: HistorySessionViewModel(provider: providerToday))
        _currentSessionProvider = StateObject(wrappedValue: current)
        _buildSessionVM = StateObject(wrappedValue: BuildSessionViewModel(provider: providerSession, currentSessionProvider: current))
        _todaySessionVM = StateObject(wrappedValue: TodaySessionViewModel(provider: providerToday, currentSessionProvider: current))
        _calendarVM = StateObject(wrappedValue: CalendarViewModel(provider: providerToday))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(buildSessionVM)
                .environmentObject(todaySessionVM)
                .environmentObject(appState)
                .environmentObject(currentSessionProvider)
                .environmentObject(settings)
                .environmentObject(history)
                .environmentObject(calendarVM)
                .environmentObject(timerSession)
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
