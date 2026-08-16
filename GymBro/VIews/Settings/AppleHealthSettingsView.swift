//
//  AppleHealthSettingsView.swift
//  GymBro
//
import SwiftUI
import HealthKit

struct AppleHealthSettingsView: View {
    @AppStorage("gymbro_healthkit_enabled") private var isEnabled: Bool = false
    @State private var showDeniedAlert = false
    @State private var isRequesting = false

    private let manager = HealthKitManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            infoCard
            toggleCard
            statusNote
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.backmain)
        .navigationTitle("Apple Health")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Access Denied", isPresented: $showDeniedAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { isEnabled = false }
        } message: {
            Text("Go to Settings → Privacy & Security → Health → GymBro to allow access.")
        }
    }

    // MARK: - Subviews

    private var infoCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: "heart.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.red)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Apple Health")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                Text("Sync finished workouts to Health app")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.5))
            }
            Spacer()
        }
        .padding(16)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    private var toggleCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.red.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
            }
            Text("Save workouts to Health")
                .font(AppFont.subheadline)
                .foregroundColor(.white)
            Spacer()
            if isRequesting {
                ProgressView().tint(.currentday)
            } else if !manager.isAvailable {
                Text("Not available")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white.opacity(0.4))
            } else {
                Toggle("", isOn: Binding(
                    get: { isEnabled },
                    set: { handleToggle($0) }
                ))
                .labelsHidden()
                .tint(.currentday)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.backbutton)
        .cornerRadius(16)
    }

    @ViewBuilder
    private var statusNote: some View {
        if !manager.isAvailable {
            Label("HealthKit is not available on this device.", systemImage: "exclamationmark.circle")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.4))
                .padding(.horizontal, 4)
        } else if isEnabled {
            Label("Finished workouts are saved as Strength Training sessions.", systemImage: "checkmark.circle")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.4))
                .padding(.horizontal, 4)
        } else {
            Text("Enable to save workouts to Apple Health after each session.")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.4))
                .padding(.horizontal, 4)
        }
    }

    // MARK: - Authorization

    private func handleToggle(_ enabled: Bool) {
        if enabled {
            requestAuthorization()
        } else {
            isEnabled = false
        }
    }

    private func requestAuthorization() {
        guard manager.isAvailable else { return }
        isRequesting = true
        Task {
            do {
                try await manager.requestAuthorization()
                let status = manager.authorizationStatus(for: HKObjectType.workoutType())
                await MainActor.run {
                    isRequesting = false
                    if status == .sharingDenied {
                        isEnabled = false
                        showDeniedAlert = true
                    } else {
                        isEnabled = true
                    }
                }
            } catch {
                await MainActor.run {
                    isRequesting = false
                    isEnabled = false
                    print("[HealthKit] Authorization error: \(error)")
                }
            }
        }
    }
}
