//
//  Settings.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel
    
    var settingsItem: [SettingsItemModel]{
        [
            SettingsItemModel(title: "My account", systemImage: "person", isShowsToggle: false),
            SettingsItemModel(title: "My goals", systemImage: "line.3.crossed.swirl.circle", isShowsToggle: false),
            SettingsItemModel(
                title: "Notification",
                systemImage: "bell.badge",
                isShowsToggle: true,
                toggleValue: $settings.isNotificationEnabled),
            SettingsItemModel(title: "Dark theme", systemImage: "moon", isShowsToggle: true, toggleValue: $settings.isDarkModeEnabled),
            SettingsItemModel(title: "Workout History", systemImage: "magazine", isShowsToggle: false),
            SettingsItemModel(title: "Weight Unit", systemImage: "scalemass", isShowsToggle: false),
            SettingsItemModel(title: "Help & Support", systemImage: "point.3.connected.trianglepath.dotted", isShowsToggle: false),
            SettingsItemModel(title: "Log Out", systemImage: "rectangle.portrait.and.arrow.right", isShowsToggle: false)
        ]
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 20){
                    MainHeader()
                    
                    ForEach(settingsItem){ item in
                        SettingsRow(
                            title: item.title,
                            systemImage: item.systemImage,
                            isShowsToggle: item.isShowsToggle,
                            toggleValue: item.toggleValue ?? .constant(false)
                        )
                        HorizontalDottedLineSettings(width: geometry.size.width - 32)
                    }
                }
                .padding(16)
            }
            .background(.backmain)
        }
    }
    
    struct SettingsRow: View {
        var title: String
        var systemImage: String
        var isShowsToggle: Bool = false
        @Binding var toggleValue: Bool
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 20){
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                    .frame(width: 22)
                    .foregroundStyle(.white)
                Text(title)
                    .font(.system(size: 20))
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                Spacer()
                if isShowsToggle {
                    Toggle("", isOn: $toggleValue)
                        .labelsHidden()
                        .scaleEffect(0.75)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
}
