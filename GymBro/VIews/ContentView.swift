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
    
    var body: some View {
        GeometryReader { _ in
            currentScreen
                .transition(
                    .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                .animation(.easeInOut(duration: 0.35), value: appState.currentScreen)
        }
//        .onAppear {
//            CoreDataSeeder.shared.deleteAllSession()
//        }
    }
    
    @ViewBuilder
    private var currentScreen: some View {
        switch appState.currentScreen {
        case .welcome:
            WelcomeView()
        case .login:
            LoginView()
        case .main:
            MainTabView()
        }
    }
}


//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.shared.context)
//}
