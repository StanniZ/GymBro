//
//  AccountView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//
import SwiftUI
import PhotosUI

struct AccountView: View {
    @EnvironmentObject var profileVM: OnboardingViewModel
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    avatarSection
                    fieldsCard
                }
                .padding(16)
            }
        }
        .navigationTitle("My Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task { try? await profileVM.saveUserProfile() }
                }
                .foregroundColor(.currentday)
                .font(AppFont.subheadline)
            }
        }
        .onChange(of: pickerItem) { _, newItem in
            profileVM.processPickedItem(newItem)
        }
    }

    // MARK: - Avatar

    private var avatarSection: some View {
        VStack(spacing: 8) {
            PhotosPicker(selection: $pickerItem, matching: .images) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let img = profileVM.userAvatar {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.currentday.opacity(0.15))
                                    .frame(width: 90, height: 90)
                                Text(initials)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.currentday)
                            }
                        }
                    }
                    ZStack {
                        Circle()
                            .fill(Color.currentday)
                            .frame(width: 26, height: 26)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            Text("Change photo")
                .font(AppFont.caption)
                .foregroundColor(.weekDay)
        }
        .padding(.top, 8)
    }

    private var initials: String {
        let parts = profileVM.userProfile.name.split(separator: " ")
        if parts.count >= 2 {
            return (String(parts[0].prefix(1)) + String(parts[1].prefix(1))).uppercased()
        }
        return String(profileVM.userProfile.name.prefix(2)).uppercased()
    }

    // MARK: - Fields

    private var fieldsCard: some View {
        VStack(spacing: 0) {
            fieldRow("Name") {
                TextField("Your name", text: $profileVM.userProfile.name)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.currentday)
                    .font(AppFont.subheadline)
            }
            divider
            fieldRow("Email") {
                TextField("Email", text: $profileVM.userProfile.email)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.currentday)
                    .font(AppFont.subheadline)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            divider
            fieldRow("Age") {
                HStack(spacing: 10) {
                    Text("\(profileVM.userProfile.age) y.o.")
                        .foregroundColor(.currentday)
                        .font(AppFont.subheadline)
                    Stepper("", value: $profileVM.userProfile.age, in: 10...100)
                        .labelsHidden()
                }
            }
            divider
            fieldRow("Height") {
                HStack(spacing: 10) {
                    Text("\(profileVM.userProfile.height) cm")
                        .foregroundColor(.currentday)
                        .font(AppFont.subheadline)
                    Stepper("", value: $profileVM.userProfile.height, in: 100...250)
                        .labelsHidden()
                }
            }
            divider
            fieldRow("Weight") {
                HStack(spacing: 10) {
                    Text(String(format: "%.1f kg", profileVM.userProfile.weight))
                        .foregroundColor(.currentday)
                        .font(AppFont.subheadline)
                    Stepper("", value: $profileVM.userProfile.weight, in: 30...250, step: 0.5)
                        .labelsHidden()
                }
            }
            divider
            fieldRow("Gender") {
                Menu {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Button(gender.displayName) {
                            profileVM.userProfile.gender = gender
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(profileVM.userProfile.gender.displayName)
                            .foregroundColor(.currentday)
                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 11))
                            .foregroundColor(.weekDay)
                    }
                    .font(AppFont.subheadline)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private func fieldRow<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        HStack {
            Text(title)
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            content()
        }
        .padding(.vertical, 14)
    }

    private var divider: some View {
        HorizontalDottedLineFull()
            .padding(.leading, 0)
    }
}
