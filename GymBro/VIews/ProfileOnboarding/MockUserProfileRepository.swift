//
//  Mock.swift
//  GymBro
//
//  Created by macbook on 03/08/2025.
//
import Foundation

class MockUserProfileRepository: UserProfileRepository {
    
    func fetchUserProfile() async throws -> UserProfile{
        return UserProfile(
                    id: UUID(),
                    name: "Тест Имя",
                    email: "test@example.com",
                    age: 25,
                    weight: 70,
                    height: 175,
                    gender: "M"
                )
    }
    
    func saveUserProfile(_ userProfile: UserProfile) async throws{
        
    }
}
