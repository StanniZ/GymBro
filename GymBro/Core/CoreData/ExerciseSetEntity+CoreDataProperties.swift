//
//  ExerciseSetEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
//

public import Foundation
public import CoreData


public typealias ExerciseSetEntityCoreDataPropertiesSet = NSSet

extension ExerciseSetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSetEntity> {
        return NSFetchRequest<ExerciseSetEntity>(entityName: "ExerciseSetEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var position: Int16
    @NSManaged public var reps: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var weightKg: Double
    @NSManaged public var exercise: SessionExerciseEntity?

}

extension ExerciseSetEntity : Identifiable {

}
