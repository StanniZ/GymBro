//
//  OnboardingViewModel.swift
//  GymBro
//
//  Created by macbook on 26/08/2025.
//
import SwiftUI
import PhotosUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    
    @Published var userProfile: UserProfile
    @Published var userAvatar: UIImage?
    
    private let repository: UserProfileRepository
    private let imageStorage: ProfileImageProtocol
    
    init(
        repository: UserProfileRepository,
        imageStorage: ProfileImageProtocol = ProfileImageService(),
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
        self.imageStorage = imageStorage
        self.userProfile = userProfile
    }
    
    func fetchUserProfile() async throws {
        do {
            var profile = try await repository.fetchUserProfile()
            // Restore photoPath from UserDefaults (not stored in CoreData model)
            profile.photoPath = UserDefaults.standard.string(forKey: "gymbro_user_photo_path")
            userProfile = profile
        } catch {
            print("Error fetching user profile: \(error.localizedDescription)")
        }
    }

    func saveUserProfile() async throws {
        do {
            try await repository.saveUserProfile(userProfile)
            // photoPath is not in CoreData — persist it separately
            UserDefaults.standard.set(userProfile.photoPath, forKey: "gymbro_user_photo_path")
            // Persist weight for CalorieEstimator
            UserDefaults.standard.set(userProfile.weight, forKey: "gymbro_user_weight_kg")
        } catch {
            print("Error saving user profile: \(error.localizedDescription)")
        }
    }
    
    func setAvatar(_ image: UIImage) {
        
        do{
            if let oldPath = userProfile.photoPath {
                try? imageStorage.deleteImage(path: oldPath)
            }
            let path = try imageStorage.saveImage(image: image)
            
            userProfile.photoPath = path
            userAvatar = image
        } catch {
            print("Image save error: \(error.localizedDescription)")
        }
    }
    
    func loadAvatar() {
        guard let path = userProfile.photoPath else { return }
        userAvatar = imageStorage.loadImage(path: path)
    }
    
    func processPickedItem(_ item: PhotosPickerItem?) {
        Task {
            guard let data = try? await item?.loadTransferable(type: Data.self),
                  let image = UIImage(data: data)
            else { return }
            setAvatar(image)
        }
    }
}
