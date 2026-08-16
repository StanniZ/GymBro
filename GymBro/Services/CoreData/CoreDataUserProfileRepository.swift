//
//  CoreDataUserProfileRepository.swift
//  GymBro
//
//  Created by macbook on 30/07/2025.
//
import Foundation
import CoreData


final class CoreDataUserProfileRepository: UserProfileRepository {
    
    static let shared = CoreDataUserProfileRepository()
    private let context: NSManagedObjectContext
        
    private init(context: NSManagedObjectContext = PersistenceController.shared.context) {
            self.context = context
    }
    
    func fetchUserProfile() async throws -> UserProfile {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else {
            throw NSError(domain: "UserProfile",
                          code: 404,
                          userInfo: [NSLocalizedDescriptionKey: "User not found"]
            )
        }
        return entity.toDomain()
    }
    
    func saveUserProfile(_ userProfile: UserProfile) async throws {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", userProfile.id as CVarArg)
        request.fetchLimit = 1
        
        let entity: UserEntity
        if let existingEntity = try context.fetch(request).first {
            entity = existingEntity
        } else {
            entity = UserEntity(context: context)
            entity.id = userProfile.id
        }
        
        entity.name = userProfile.name
        entity.email = userProfile.email
        entity.age = Int16(userProfile.age)
        entity.weight = Double(userProfile.weight)
        entity.height = Int16(userProfile.height)
        entity.gender = userProfile.gender.displayName
        // photoPath is not in the CoreData model — persisted via UserDefaults in OnboardingViewModel
        
        try context.save()
    }
    
}
