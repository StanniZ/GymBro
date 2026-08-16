//
//  SupportView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//
import SwiftUI

struct SupportView: View {
    private let appVersion: String = {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }()

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    linksCard
                    versionCard
                }
                .padding(16)
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var linksCard: some View {
        VStack(spacing: 0) {
            supportRow(icon: "star.fill", iconColor: .orange, title: "Rate GymBro") {
                openURL("https://apps.apple.com")
            }
            HorizontalDottedLineFull().padding(.leading, 50)
            supportRow(icon: "envelope.fill", iconColor: .currentday, title: "Send Feedback") {
                openURL("mailto:support@gymbro.app")
            }
            HorizontalDottedLineFull().padding(.leading, 50)
            supportRow(icon: "lock.shield.fill", iconColor: .teal, title: "Privacy Policy") {
                openURL("https://gymbro.app/privacy")
            }
        }
        .padding(.horizontal, 16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private func supportRow(icon: String, iconColor: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 13))
                    .foregroundColor(.weekDay)
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }

    private var versionCard: some View {
        HStack {
            Text("Version")
                .font(AppFont.subheadline)
                .foregroundColor(.weekDay)
            Spacer()
            Text(appVersion)
                .font(AppFont.subheadline)
                .foregroundColor(.weekDay)
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private func openURL(_ string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }
}
