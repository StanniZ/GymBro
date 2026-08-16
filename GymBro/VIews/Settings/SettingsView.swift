//
//  SettingsView.swift
//  GymBro
//
//  Created by macbook on 06/06/2025.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    @EnvironmentObject var profileVM: OnboardingViewModel

    private let configuration = SettingsConfigurationBuilder.build()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    profileCard
                    sectionsStack
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .background(Color.backmain)
            .navigationBarHidden(true)
        }
        .task { try? await profileVM.fetchUserProfile() }
    }

    // MARK: - Profile card

    private var profileCard: some View {
        HStack(spacing: 16) {
            avatarCircle
            VStack(alignment: .leading, spacing: 6) {
                Text(profileVM.userProfile.name.isEmpty ? "Your Name" : profileVM.userProfile.name)
                    .font(AppFont.body)
                    .foregroundColor(.white)
                HStack(spacing: 8) {
                    statChip("\(profileVM.userProfile.age) y.o.")
                    statChip("\(Int(profileVM.userProfile.weight)) kg")
                    statChip("\(profileVM.userProfile.height) cm")
                }
            }
            Spacer()
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    @ViewBuilder
    private var avatarCircle: some View {
        ZStack {
            Circle()
                .fill(Color.currentday.opacity(0.15))
                .frame(width: 64, height: 64)
            if let img = profileVM.userAvatar {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
            } else {
                Text(initials)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.currentday)
            }
        }
    }

    private var initials: String {
        let parts = profileVM.userProfile.name.split(separator: " ")
        if parts.count >= 2 {
            return (String(parts[0].prefix(1)) + String(parts[1].prefix(1))).uppercased()
        }
        return String(profileVM.userProfile.name.prefix(2)).uppercased()
    }

    private func statChip(_ text: String) -> some View {
        Text(text)
            .font(AppFont.caption)
            .foregroundColor(.weekDay)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.backmain)
            .cornerRadius(6)
    }

    // MARK: - Sections

    private var sectionsStack: some View {
        VStack(spacing: 20) {
            ForEach(configuration.sections) { section in
                VStack(alignment: .leading, spacing: 8) {
                    Text(section.header.uppercased())
                        .font(AppFont.caption)
                        .foregroundColor(.weekDay)
                        .padding(.leading, 4)

                    sectionCard(section)
                }
            }
        }
    }

    private func sectionCard(_ section: SettingsConfiguration.Section) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(section.items.enumerated()), id: \.offset) { index, item in
                SettingsItemView(item: item, viewModel: viewModel)
                if index < section.items.count - 1 {
                    HorizontalDottedLineFull()
                        .padding(.leading, 50)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }
}
