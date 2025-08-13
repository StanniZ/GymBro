//
//  OnboardingViewModel.swift
//  GymBro
//
//  Created by macbook on 03/08/2025.
//
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    
    private let repository: any UserProfileRepository
    
    init(repository: any UserProfileRepository) {
        self.repository = repository
        self.userProfile = UserProfile(
            id: UUID(),
            name: "",
            email: "",
            age: 25,
            weight: 60.5,
            height: 160,
            gender: ""
        )
    }
    
    @MainActor
    func saveProfile() async {
        do {
            try await repository.saveUserProfile(userProfile)
        } catch {
            print("Errors saving user profile: \(error.localizedDescription)")
        }
    }

}
