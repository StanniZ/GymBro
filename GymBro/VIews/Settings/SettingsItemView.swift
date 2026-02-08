//
//  SettingsItemView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//

import SwiftUI

struct SettingsItemView: View {
    
    let item: SettingsConfiguration.Item
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        switch item {
            
        case .toggle(_, let model):
            SettingsRowView(title: model.title, icon: model.icon) {
                Toggle("", isOn: binding(for: model.key))
                    .labelsHidden()
            }
                
            
        case .navigation(_, let model):
            NavigationLink(destination: destinationView(for: model.destination)) {
                SettingsRowView(title: model.title, icon: model.icon) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.gray)
                }
            }
            
        }
    }
    
    private func binding(for key: ToggleKey) -> Binding<Bool> {
        switch key {
        case .notifications:
            return $viewModel.isNotificationsEnabled
        case .darkMode:
            return $viewModel.isDarkModeEnabled
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: SettingsDestination) -> some View {
        switch destination {
        case .account:
            AccountView()
        case .goals:
            GoalsView()
        case .support:
            SupportView()
        case .weightUnit:
            WeightUnitView()
        case .workoutHistory:
            WorkoutHistoryView()
        case .logout:
            LogoutView()
        }
    }
}

struct SettingsRowView<Accessory: View>: View {
    let title: String
    let icon: String
    let accessory: Accessory
    
    init(title: String, icon: String, @ViewBuilder accessory: () -> Accessory) {
        self.title = title
        self.icon = icon
        self.accessory = accessory()
    }
    
    var body: some View{
        HStack {
            Image(systemName: icon)
                .font(.system(size: 22))
                .frame(width: 22)
                .foregroundStyle(.white)
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.light)
                .foregroundStyle(.white)
            Spacer()
            
            accessory
        }
    }
}

