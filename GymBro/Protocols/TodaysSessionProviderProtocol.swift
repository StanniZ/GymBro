//
//  TodaysSessionProviderProtocol.swift
//  GymBro
//
//  Created by macbook on 22/06/2025.
//
import Foundation

protocol TodaysSessionProviderProtocol {
    func fetchTodaysSession() -> TrainingSessionModel?
    
    func saveTodaysSession(_ session: TrainingSessionModel) async throws
    
    func finishTodaysSession(_ session: TrainingSessionModel) async throws
}
