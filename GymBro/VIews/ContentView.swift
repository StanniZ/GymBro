//
//  ContentView.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//
//
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State private var welcomeViewShown: Bool = true
    
    var body: some View {
        ZStack {
            switch appState.phase {
            case .firstLaunch:
                FirstLaunchFlowView()
                    .transition(.move(edge: .trailing))
            case .mainFlow:
                MainTabView()
                    .transition(.move(edge: .trailing))
            }
            
            if welcomeViewShown {
                WelcomeView {
                    withAnimation(.easeInOut(duration: 2.0)){
                        welcomeViewShown = false
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 2.0), value: appState.phase)
//        .onAppear {
//            CoreDataSeeder.shared.deleteAllSession()
//        }
    }
}

struct FirstLaunchFlowView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject private var authSession: AuthSession
    @State private var step: Step = .onboarding
    
    enum Step {
        case onboarding
        case login
    }
    var body: some View {
        switch step {
        case .onboarding:
            OnboardingView {
                if authSession.isAuthenticated {
                    appState.completeFirstLaunch()
                } else {
                    step = .login
                }
            }
        case .login:
            LoginView {
                appState.completeFirstLaunch()
            }
        }
    }
}
