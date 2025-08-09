//
//  UserProfile.swift
//  GymBro
//
//  Created by macbook on 29/07/2025.
//
import Foundation
import CoreData

struct UserProfile: Codable {
    let id: UUID
    var name: String
    var email: String
    var age: Int
    var weight: Double
    var height: Double
    var gender: String
}
