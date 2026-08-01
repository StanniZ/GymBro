//
//  TodaysSessionProviderProtocol.swift
//  GymBro
//
//  Created by macbook on 22/06/2025.
//
import Foundation

protocol WorkoutSessionProviderProtocol {
    
    func saveTodaysSession(_ session: TrainingSessionModel) async throws
    
    func finishTodaysSession(_ session: TrainingSessionModel) async throws
    
    func getAllFinishedSessions() async throws -> [TrainingSessionModel]
    
    func deleteSession(with id: UUID) async throws 
}
