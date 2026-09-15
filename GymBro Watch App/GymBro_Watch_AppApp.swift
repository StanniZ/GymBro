//
//  GymBro_Watch_AppApp.swift
//  GymBro Watch App
//
//  Created by macbook on 14/09/2026.
//

import SwiftUI

@main
struct GymBro_Watch_App_Watch_AppApp: App {
    @StateObject private var workoutViewModel = WatchWorkoutViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutViewModel)
        }
    }
}
