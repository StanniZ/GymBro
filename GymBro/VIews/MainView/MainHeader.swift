//
//  MainHeader.swift
//  GymBro
//
//  Created by macbook on 02/06/2025.
//
import SwiftUI

struct MainHeader: View {
    @EnvironmentObject var profileVM: OnboardingViewModel

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<21: return "Good Evening"
        default:      return "Good Night"
        }
    }

    private var displayName: String {
        let name = profileVM.userProfile.name
        if name.isEmpty { return "Athlete" }
        return name.components(separatedBy: " ").first ?? name
    }

    private var initials: String {
        let parts = profileVM.userProfile.name.split(separator: " ")
        if parts.count >= 2 {
            return (String(parts[0].prefix(1)) + String(parts[1].prefix(1))).uppercased()
        }
        let name = profileVM.userProfile.name
        return name.isEmpty ? "A" : String(name.prefix(2)).uppercased()
    }

    var body: some View {
        HStack {
            avatarView

            VStack(alignment: .leading, spacing: 2) {
                Text(greeting)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.titlewords)
                Text(displayName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            notificationButton
        }
        .task {
            try? await profileVM.fetchUserProfile()
            profileVM.loadAvatar()
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color.currentday.opacity(0.15))
                .frame(width: 40, height: 40)
            if let img = profileVM.userAvatar {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Text(initials)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.currentday)
            }
        }
    }

    private var notificationButton: some View {
        Button(action: {}) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                Circle()
                    .fill(Color.notificationbtn)
                    .frame(width: 7, height: 7)
                    .offset(x: -1, y: 0)
            }
            .frame(width: 40, height: 40)
            .background(Color.backbutton)
            .cornerRadius(16)
        }
    }
}
