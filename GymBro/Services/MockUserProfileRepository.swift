//
//  Mock.swift
//  GymBro
//
//  Created by macbook on 03/08/2025.
//
import Foundation

final class MockUserProfileRepository: UserProfileRepository {
    
    
    func fetchUserProfile() async throws -> UserProfile{
        return UserProfile(
                    id: UUID(),
                    name: "Тест Имя",
                    email: "test@example.com",
                    age: 25,
                    weight: 70,
                    height: 175,
                    gender: .female
                )
    }
    
    func saveUserProfile(_ userProfile: UserProfile) async throws{
    }
}
