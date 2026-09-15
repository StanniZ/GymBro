//
//  WatchConnectivityClient.swift
//  GymBro Watch App
//
//  Created by Codex on 15/09/2026.
//

import Combine
import Foundation
import WatchConnectivity

@MainActor
final class WatchConnectivityClient: NSObject, ObservableObject {
    @Published private(set) var templates: [WatchWorkoutTemplate] = []
    @Published private(set) var isReachable: Bool = false

    private let session: WCSession?
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let cacheKey = "watch_templates_snapshot_payload"

    init(session: WCSession? = WCSession.isSupported() ? .default : nil) {
        self.session = session
        super.init()
        loadCachedTemplates()
        activate()
    }

    func requestTemplates() {
        guard let session, session.activationState == .activated else { return }

        let message: [String: Any] = [
            WatchSyncMessageKey.type: WatchSyncMessageType.requestTemplates
        ]

        if session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }

    func submitFinishedWorkout(_ sessionModel: WatchWorkoutSession) throws {
        guard let session, session.activationState == .activated else { return }

        let payload = sessionModel.finishedPayload()
        let data = try encoder.encode(payload)
        let userInfo: [String: Any] = [
            WatchSyncMessageKey.type: WatchSyncMessageType.workoutCompleted,
            WatchSyncMessageKey.payload: data
        ]
        session.transferUserInfo(userInfo)
    }

    private func activate() {
        guard let session else { return }
        session.delegate = self
        session.activate()
    }

    private func applySnapshotData(_ data: Data) {
        guard let snapshot = try? decoder.decode(WatchTemplatesSnapshotPayload.self, from: data) else { return }
        templates = snapshot.templates.map(WatchWorkoutTemplate.init(payload:))
        UserDefaults.standard.set(data, forKey: cacheKey)
    }

    private func loadCachedTemplates() {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else { return }
        applySnapshotData(data)
    }
}

extension WatchConnectivityClient: WCSessionDelegate {
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
            isReachable = session.isReachable
            requestTemplates()
        }
    }

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Task { @MainActor in
            isReachable = session.isReachable
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        guard let data = applicationContext[WatchSyncMessageKey.payload] as? Data else { return }
        Task { @MainActor in
            applySnapshotData(data)
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        guard userInfo[WatchSyncMessageKey.type] as? String == WatchSyncMessageType.templatesSnapshot,
              let data = userInfo[WatchSyncMessageKey.payload] as? Data else { return }

        Task { @MainActor in
            applySnapshotData(data)
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        guard message[WatchSyncMessageKey.type] as? String == WatchSyncMessageType.templatesSnapshot,
              let data = message[WatchSyncMessageKey.payload] as? Data else { return }

        Task { @MainActor in
            applySnapshotData(data)
        }
    }
}
