//
//  UserEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 29/07/2025.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var age: Int16
    @NSManaged public var weight: Double
    @NSManaged public var height: Int16
    @NSManaged public var gender: String?

}
