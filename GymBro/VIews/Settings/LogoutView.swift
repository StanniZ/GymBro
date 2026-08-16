//
//  LogoutView.swift
//  GymBro
//
//  Created by macbook on 06/02/2026.
//
import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.backmain.ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                iconSection
                textSection
                actionsSection
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .navigationTitle("Log Out")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backmain, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.1))
                .frame(width: 90, height: 90)
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .font(.system(size: 36))
                .foregroundColor(.red)
        }
    }

    private var textSection: some View {
        VStack(spacing: 10) {
            Text("Are you sure?")
                .font(AppFont.headline)
                .foregroundColor(.white)
            Text("You will be returned to the welcome screen. Your workout data will be kept on this device.")
                .font(AppFont.subheadline)
                .foregroundColor(.weekDay)
                .multilineTextAlignment(.center)
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button(action: { appState.logout() }) {
                Text("Log Out")
                    .font(AppFont.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .cornerRadius(14)
            }
            Button(action: { dismiss() }) {
                Text("Cancel")
                    .font(AppFont.body)
                    .foregroundColor(.weekDay)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.backbutton)
                    .cornerRadius(14)
            }
        }
    }
}
