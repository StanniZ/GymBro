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
            Color.backmain.ignoresSafeArea()

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
        .background(Color.backmain.ignoresSafeArea())
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
                    withAnimation(.easeInOut(duration: 0.45)) {
                        appState.completeFirstLaunch()
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        step = .login
                    }
                }
            }
            .transition(.opacity)
        case .login:
            LoginView {
                withAnimation(.easeInOut(duration: 0.45)) {
                    appState.completeFirstLaunch()
                }
            }
            .transition(.opacity)
        }
    }
}
