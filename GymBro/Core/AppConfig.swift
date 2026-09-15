//
//  AppConfig.swift
//  GymBro
//
//  Created by Codex on 30/08/2026.
//

import Foundation

enum AppConfig {
    enum API {
        #if DEBUG
        static let baseURL = URL(string: "http://192.168.64.2:8000")!
        #else
        static let baseURL = URL(string: "https://api.gymbro.app")!
        #endif
    }
}
