//
//  СurrentSessionProviding.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
import SwiftUI

protocol CurrentSessionProviding {
    func setCurrentSession(_ session: TrainingSessionModel)
    
    func clearCurrentSession()
}
