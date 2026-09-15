//
//  AppState.swift
//  GymBro
//
//  Created by macbook on 19/07/2025.
//
import SwiftUI

final class AppState: ObservableObject {

    @AppStorage("hasCompletedFirstLaunch") private var hasCompletedFirstLaunch: Bool = false

    @Published var phase: AppPhase = .firstLaunch

    init() {
        self.phase = hasCompletedFirstLaunch ? .mainFlow : .firstLaunch
    }

    func completeFirstLaunch() {
        hasCompletedFirstLaunch = true
        phase = .mainFlow
    }
}

enum AppPhase {
    case firstLaunch
    case mainFlow
}
