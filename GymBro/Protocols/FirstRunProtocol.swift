//
//  FirstRunProtocol.swift
//  GymBro
//
//  Created by macbook on 26/08/2025.
//
import Foundation

protocol FirstRunProtocol {
    var isFirstRun: Bool { get }
    func firstRunCompleted()
}
