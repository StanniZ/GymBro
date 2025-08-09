//
//  MainView.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//

import SwiftUI
import CoreData

struct MainView: View {
    @EnvironmentObject var currentSessionProvider: CurrentSessionProvider

    @StateObject private var buildSessionVM: BuildSessionViewModel
    @StateObject private var todaySessionVM: TodaySessionViewModel

    init(currentSessionProvider: CurrentSessionProvider) {
        let context = PersistenceController.shared.container.viewContext
        let container = PersistenceController.shared.container

        _buildSessionVM = StateObject(wrappedValue: BuildSessionViewModel(
            provider: CoreDataTrainingSessionProvider(context: context),
            currentSessionProvider: currentSessionProvider
        ))

        _todaySessionVM = StateObject(wrappedValue: TodaySessionViewModel(
            provider: CoreDataTodaysSessionProvider(context: context, container: container),
            currentSessionProvider: currentSessionProvider
        ))
    }
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading){
                    MainHeader()
                    MainTrainCelendarView()
                    BuildSessionScrollView(viewModel: buildSessionVM)
                    TodaysWorkoutView(viewModel: todaySessionVM)
                }
                .padding(.horizontal, 16)
            }
            .background(Color.backmain)
        }
    }
}

