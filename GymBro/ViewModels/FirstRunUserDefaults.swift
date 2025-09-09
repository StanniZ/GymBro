//
//  FirstRunDefaults.swift
//  GymBro
//
//  Created by macbook on 26/08/2025.
//
import Foundation

final class FirstRunUserDefaults: FirstRunProtocol {
    private let key = "hasCompletedFirstRun"
    
    var isFirstRun: Bool { !UserDefaults.standard.bool(forKey: key) }
    
    func firstRunCompleted() { UserDefaults.standard.set(true, forKey: key) }
}
