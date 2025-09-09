//
//  OnboardingViewModel.swift
//  GymBro
//
//  Created by macbook on 26/08/2025.
//
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    
    @Published var userProfile: UserProfile
    private let repository: UserProfileRepository
    
    init(
        repository: CoreDataUserProfileRepository,
        userProfile: UserProfile = UserProfile(
            id: UUID(),
            name: "",
            email: "",
            age: 25,
            weight: 60.5,
            height: 170,
            gender: Gender.uknown)
    ) {
        self.repository = repository
        self.userProfile = userProfile
    }
    
    func fetchUserProfile() async throws{
        do {
            userProfile = try await repository.fetchUserProfile()
        } catch {
            print("Error fetching user profile: \(error.localizedDescription)")
        }
    }
    
    func saveUserProfile() async throws {
        do {
            try await repository.saveUserProfile(userProfile)
        } catch {
            print("Error saving user profile: \(error.localizedDescription)")
        }
    }
    
    
}
