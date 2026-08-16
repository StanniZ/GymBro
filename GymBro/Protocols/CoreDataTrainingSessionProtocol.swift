//
//  CoreDataTrainingSessionProtocol.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import Foundation

@MainActor
protocol CoreDataTrainingSessionProtocol {
    
    func fetchUnfinishedSessions() throws -> [TrainingSessionModel]
    
}
