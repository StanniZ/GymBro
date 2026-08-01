//
//  MainView.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//

import SwiftUI
import CoreData

struct MainView: View {
    @EnvironmentObject var currentSessionManager: CurrentSessionManager
    @EnvironmentObject var buildSessionVM: BuiltInTemplatesViewModel
    @EnvironmentObject var todaySessionVM: TodaySessionViewModel
    @EnvironmentObject var calendarVM: CalendarViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    MainHeader()
                    MainTrainCelendarView(viewModel: calendarVM)
                    BuildSessionScrollView(viewModel: buildSessionVM)
                    TodaysWorkoutView(currentSession: currentSessionManager)
                }
                .padding(.horizontal, 16)
            }
            .background(Color.backmain)
        }
    }
}


#Preview {
    let persistence = PersistenceController.preview
    let sessionManager = CurrentSessionManager()
    let provider = CoreDataWorkoutSessionProvider(
        context: persistence.context,
        container: persistence.container
    )
    let templateRepository = CoreDataWorkoutTemplateRepository(
        context: persistence.context,
        container: persistence.container
    )
    MainView()
        .environmentObject(sessionManager)
        .environmentObject(BuiltInTemplatesViewModel(
            currentSessionProvider: sessionManager,
            templateRepository: templateRepository,
            sessionProvider: provider
        ))
        .environmentObject(TodaySessionViewModel(provider: provider, currentSessionProvider: sessionManager))
        .environmentObject(CalendarViewModel(provider: provider))
        .environmentObject(SessionTimerViewModel())
}
