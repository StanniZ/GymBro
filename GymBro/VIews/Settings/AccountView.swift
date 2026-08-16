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
    @State private var saveSuccess = false

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    avatarSection
                    infoCard
                    physicalCard
                }
                .padding(16)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("My Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(saveSuccess ? "Saved ✓" : "Save") {
                    Task {
                        try? await profileVM.saveUserProfile()
                        saveSuccess = true
                        try? await Task.sleep(for: .seconds(2))
                        saveSuccess = false
                    }
                }
                .foregroundColor(saveSuccess ? .currentday : .white)
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
                                .resizable().scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                        } else {
                            ZStack {
                                Circle().fill(Color.currentday.opacity(0.15))
                                    .frame(width: 96, height: 96)
                                Text(initials)
                                    .font(.system(size: 34, weight: .bold))
                                    .foregroundColor(.currentday)
                            }
                        }
                    }
                    ZStack {
                        Circle().fill(Color.currentday).frame(width: 28, height: 28)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 13)).foregroundColor(.white)
                    }
                    .offset(x: 2, y: 2)
                }
            }
            Text("Change photo")
                .font(AppFont.caption)
                .foregroundColor(.weekDay)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var initials: String {
        let parts = profileVM.userProfile.name.split(separator: " ")
        if parts.count >= 2 {
            return (String(parts[0].prefix(1)) + String(parts[1].prefix(1))).uppercased()
        }
        return String(profileVM.userProfile.name.prefix(2)).uppercased()
    }

    // MARK: - Info Card (Name / Email / Gender)

    private var infoCard: some View {
        VStack(spacing: 0) {
            cardHeader(title: "Personal Info", icon: "person.fill", color: .currentday)
            Divider().background(Color.white.opacity(0.06))

            textRow("Name", placeholder: "Your name", text: $profileVM.userProfile.name)
            Divider().background(Color.white.opacity(0.06)).padding(.leading, 16)

            textRow("Email", placeholder: "email@example.com", text: $profileVM.userProfile.email,
                    keyboardType: .emailAddress)
            Divider().background(Color.white.opacity(0.06)).padding(.leading, 16)

            genderRow
        }
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Physical Card (Age / Height / Weight)

    private var physicalCard: some View {
        VStack(spacing: 0) {
            cardHeader(title: "Physical Parameters", icon: "figure.stand", color: .orange)
            Divider().background(Color.white.opacity(0.06))

            VStack(spacing: 0) {
                IntFieldRow(label: "Age", unit: "y.o.",
                            value: $profileVM.userProfile.age, range: 10...100)
                Divider().background(Color.white.opacity(0.06))

                IntFieldRow(label: "Height", unit: "cm",
                            value: $profileVM.userProfile.height, range: 100...250)
                Divider().background(Color.white.opacity(0.06))

                DoubleFieldRow(label: "Weight", unit: "kg",
                               value: $profileVM.userProfile.weight,
                               range: 30...250, step: 0.5, fractionDigits: 1)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.backbutton)
        .cornerRadius(20)
    }

    // MARK: - Row Builders

    private func cardHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
            Text(title)
                .font(AppFont.body)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func textRow(_ label: String, placeholder: String,
                         text: Binding<String>,
                         keyboardType: UIKeyboardType = .default) -> some View {
        HStack {
            Text(label)
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            TextField(placeholder, text: text)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.currentday)
                .font(AppFont.subheadline)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .frame(maxWidth: 180)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private var genderRow: some View {
        HStack {
            Text("Gender")
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            Menu {
                ForEach(Gender.allCases, id: \.self) { g in
                    Button(g.displayName) { profileVM.userProfile.gender = g }
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
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
