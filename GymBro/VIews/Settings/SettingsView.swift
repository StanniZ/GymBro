//
//  Settings.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    private let configuration = SettingsConfigurationBuilder.build()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10){
                
                MainHeader()
                title
                
                ScrollView{
                    LazyVStack(spacing: 16) {
                        
                        ForEach(configuration.sections) { section in
                            SettingsSectionView(section: section, viewModel: viewModel)
                                .padding(1)
                        }
                    }
                }
            }
            .padding(16)
            .background(Color.backmain)
        }
    }
    
    private var title: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.8))
            Spacer()
        }
        .padding(.bottom, 10)
    }
}

struct SettingsSectionView: View {
    
    let section: SettingsConfiguration.Section
    let viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 0){
            ForEach(Array(section.items.enumerated()), id: \.offset) { index, item in
                SettingsItemView(item: item, viewModel: viewModel)
                if index < section.items.count - 1 {
                    HorizontalDottedLineFull()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.backbutton)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.3), lineWidth: 0.5))
    }
}
