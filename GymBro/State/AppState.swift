//
//  AppState.swift
//  GymBro
//
//  Created by macbook on 19/07/2025.
//
import Foundation

final class AppState: ObservableObject {
    
    @Published var currentScreen: AppScreen = .welcome
    
}


enum AppScreen {
    case welcome
    case login
    case main
}
