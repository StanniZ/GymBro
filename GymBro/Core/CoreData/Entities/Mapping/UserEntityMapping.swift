//
//  UserEntityMapping.swift
//  GymBro
//
//  Created by macbook on 29/07/2025.
//
import Foundation
import CoreData

extension UserEntity : Identifiable {
    func toDomain() -> UserProfile{
        UserProfile(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            email: self.email ?? "",
            age: Int(self.age),
            weight: self.weight,
            height: Int(self.height),
            gender: Gender(databaseString: gender)
        )
    }
}

extension UserProfile {
    func toEntity(in context: NSManagedObjectContext) -> UserEntity{
        let entity = UserEntity(context: context)
        entity.id = id
        entity.name = name
        entity.email = email
        entity.age = Int16(age)
        entity.weight = Double(weight)
        entity.height = Int16(height)
        entity.gender = gender.rawValue
        return entity
    }
}
