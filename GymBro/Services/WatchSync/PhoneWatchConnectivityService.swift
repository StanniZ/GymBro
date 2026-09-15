//
//  PhoneWatchConnectivityService.swift
//  GymBro
//
//  Created by Codex on 15/09/2026.
//

import Combine
import Foundation
import WatchConnectivity

@MainActor
final class PhoneWatchConnectivityService: NSObject, ObservableObject {
    @Published private(set) var isReachable: Bool = false
    @Published private(set) var lastFinishedWorkout: PhoneWatchFinishedWorkoutPayload?

    private let session: WCSession?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var latestTemplates: [WorkoutTemplateModel] = []

    init(session: WCSession? = WCSession.isSupported() ? .default : nil) {
        self.session = session
        super.init()
        activate()
    }

    func syncTemplates(_ templates: [WorkoutTemplateModel]) {
        latestTemplates = templates
        sendTemplatesSnapshot()
    }

    private func activate() {
        guard let session else { return }
        session.delegate = self
        session.activate()
    }

    private func sendTemplatesSnapshot() {
        guard let session, session.activationState == .activated else { return }
        guard session.isPaired, session.isWatchAppInstalled else { return }
        guard let data = try? encoder.encode(PhoneWatchWorkoutMapper.makeSnapshot(from: latestTemplates)) else { return }

        let message: [String: Any] = [
            PhoneWatchSyncMessageKey.type: PhoneWatchSyncMessageType.templatesSnapshot,
            PhoneWatchSyncMessageKey.payload: data
        ]

        try? session.updateApplicationContext(message)

        if session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
        } else {
            session.transferUserInfo(message)
        }
    }

    private func handleFinishedWorkoutData(_ data: Data) {
        guard let payload = try? decoder.decode(PhoneWatchFinishedWorkoutPayload.self, from: data) else { return }
        lastFinishedWorkout = payload
    }
}

extension PhoneWatchConnectivityService: WCSessionDelegate {
    nonisolated func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        Task { @MainActor in
            isReachable = session.isReachable
            sendTemplatesSnapshot()
        }
    }

    nonisolated func sessionDidBecomeInactive(_ session: WCSession) {}

    nonisolated func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }

    nonisolated func sessionReachabilityDidChange(_ session: WCSession) {
        Task { @MainActor in
            isReachable = session.isReachable
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        Task { @MainActor in
            if message[PhoneWatchSyncMessageKey.type] as? String == PhoneWatchSyncMessageType.requestTemplates {
                sendTemplatesSnapshot()
            } else if message[PhoneWatchSyncMessageKey.type] as? String == PhoneWatchSyncMessageType.workoutCompleted,
                      let data = message[PhoneWatchSyncMessageKey.payload] as? Data {
                handleFinishedWorkoutData(data)
            }
        }
    }

    nonisolated func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        guard userInfo[PhoneWatchSyncMessageKey.type] as? String == PhoneWatchSyncMessageType.workoutCompleted,
              let data = userInfo[PhoneWatchSyncMessageKey.payload] as? Data else { return }

        Task { @MainActor in
            handleFinishedWorkoutData(data)
        }
    }
}
