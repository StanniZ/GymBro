//
//  ExerciseSetEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 14/06/2025.
//
//

import Foundation
import CoreData


extension ExerciseSetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSetEntity> {
        return NSFetchRequest<ExerciseSetEntity>(entityName: "ExerciseSetEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var reps: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var weightKg: Double
    @NSManaged public var exercise: ExerciseEntity?

}

