//
//  StatisticsProtocol.swift
//  GymBro
//
//  Created by macbook on 10/09/2025.
//
import Foundation

protocol StatisticsProtocol {
    func getAllFinishedSessions() async throws -> [TrainingSessionModel]
    func deleteSession(with id: UUID) async throws
}
