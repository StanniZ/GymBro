//
//  ExerciseEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 14/06/2025.
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var session: TrainingSessionEntity?
    @NSManaged public var sets: NSSet?

}
