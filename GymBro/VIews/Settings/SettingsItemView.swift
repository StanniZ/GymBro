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
            SettingsRowView(title: model.title, icon: model.icon, iconColor: model.iconColor.solidColor) {
                Toggle("", isOn: binding(for: model.key))
                    .labelsHidden()
                    .tint(.currentday)
            }

        case .navigation(_, let model):
            NavigationLink(destination: destinationView(for: model.destination)) {
                SettingsRowView(title: model.title, icon: model.icon, iconColor: model.iconColor.solidColor) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.weekDay)
                }
            }
        }
    }

    private func binding(for key: ToggleKey) -> Binding<Bool> {
        switch key {
        case .notifications: return $viewModel.isNotificationsEnabled
        case .darkMode:      return $viewModel.isDarkModeEnabled
        }
    }

    @ViewBuilder
    private func destinationView(for destination: SettingsDestination) -> some View {
        switch destination {
        case .account:        AccountView()
        case .goals:          GoalsView()
        case .support:        SupportView()
        case .weightUnit:     WeightUnitView(viewModel: viewModel)
        case .workoutHistory: HistorySessionView()
        case .appleHealth:    AppleHealthSettingsView()
        case .logout:         LogoutView()
        }
    }
}

// MARK: - Row

struct SettingsRowView<Accessory: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let accessory: Accessory

    init(title: String, icon: String, iconColor: Color = .currentday, @ViewBuilder accessory: () -> Accessory) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.accessory = accessory()
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            Text(title)
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            accessory
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
