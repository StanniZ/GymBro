//
//  AppState.swift
//  GymBro
//
//  Created by macbook on 19/07/2025.
//
import SwiftUI

final class AppState: ObservableObject {

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("didChooseGuest") private var didChooseGuest: Bool = false
    @AppStorage("hasCompletedFirstLaunch") private var hasCompletedFirstLaunch: Bool = false

    @Published var phase: AppPhase = .firstLaunch

    init() {
        self.phase = hasCompletedFirstLaunch ? .mainFlow : .firstLaunch
    }

    func completeFirstLaunch() {
        hasCompletedFirstLaunch = true
        phase = .mainFlow
    }

    func logout() {
        hasCompletedFirstLaunch = false
        hasSeenOnboarding = false
        isLoggedIn = false
        didChooseGuest = false
        phase = .firstLaunch
    }
}

enum AppPhase {
    case firstLaunch
    case mainFlow
}
