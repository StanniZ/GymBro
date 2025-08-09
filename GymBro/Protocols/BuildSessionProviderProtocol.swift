//
//  TrainingSessionProviderProtocol.swift
//  GymBro
//
//  Created by macbook on 20/06/2025.
//

import Foundation

protocol BuildSessionProviderProtocol {
    func fetchSessions() -> [TrainingSessionModel]
}
