//
//  SessionTimerProtocol.swift
//  GymBro
//
//  Created by macbook on 15/11/2025.
//
import Foundation

protocol SessionTimerProtocol {
    var elapsedTime: TimeInterval { get }
    var isRunning: Bool { get }
    
    func start()
    func finishSession()
}
