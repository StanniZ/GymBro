//
//  GymBroApp.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//
import SwiftUI

@main
@MainActor
struct GymBroApp: App {

    private let persistenceController: PersistenceController

    @StateObject private var buildSessionVM: BuiltInTemplatesViewModel
    @StateObject private var todaySessionVM: TodaySessionViewModel
    @StateObject private var calendarVM: CalendarViewModel
    @StateObject private var currentSessionProvider: CurrentSessionManager
    @StateObject private var timerSession = SessionTimerViewModel()
    @StateObject private var appState = AppState()
    @StateObject private var settings = SettingsViewModel()
    @StateObject private var history: HistorySessionViewModel
    @StateObject private var profileVM: OnboardingViewModel
    @StateObject private var foodVM = FoodTrackerViewModel()

    init() {
        let persistenceController = PersistenceController.shared
        let currentSessionProvider = CurrentSessionManager()
        let todayProvider = CoreDataWorkoutSessionProvider(
            context: persistenceController.context,
            container: persistenceController.container
        )
        let templateRepository = CoreDataWorkoutTemplateRepository(
            context: persistenceController.context,
            container: persistenceController.container
        )
        self.persistenceController = persistenceController

        _history = StateObject(wrappedValue: HistorySessionViewModel(provider: todayProvider))
        _currentSessionProvider = StateObject(wrappedValue: currentSessionProvider)
        _buildSessionVM = StateObject(wrappedValue: BuiltInTemplatesViewModel(
            currentSessionProvider: currentSessionProvider,
            templateRepository: templateRepository,
            sessionProvider: todayProvider
        ))
        _todaySessionVM = StateObject(wrappedValue: TodaySessionViewModel(
            provider: todayProvider,
            currentSessionProvider: currentSessionProvider
        ))
        _calendarVM = StateObject(wrappedValue: CalendarViewModel(provider: todayProvider))
        _profileVM = StateObject(wrappedValue: OnboardingViewModel(
            repository: CoreDataUserProfileRepository.shared
        ))
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
                .environmentObject(profileVM)
                .environmentObject(foodVM)
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
