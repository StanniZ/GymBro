//
//  UserProtocol.swift
//  GymBro
//
//  Created by macbook on 30/07/2025.
//
import Foundation

protocol UserProfileRepository {
    func fetchUserProfile() async throws -> UserProfile
    
    func saveUserProfile(_ userProfile: UserProfile) async throws
}
