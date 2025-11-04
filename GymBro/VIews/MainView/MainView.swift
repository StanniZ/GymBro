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
    @EnvironmentObject var buildSessionVM: BuildSessionViewModel
    @EnvironmentObject var todaySessionVM: TodaySessionViewModel
    @EnvironmentObject var calendarVM: CalendarViewModel
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .leading){
                    MainHeader()
                    MainTrainCelendarView(viewModel: calendarVM)
                    BuildSessionScrollView(viewModel: buildSessionVM)
                    TodaysWorkoutView(viewModel: todaySessionVM)
                }
                .padding(.horizontal, 16)
            }
            .background(Color.backmain)
        }
    }
}

