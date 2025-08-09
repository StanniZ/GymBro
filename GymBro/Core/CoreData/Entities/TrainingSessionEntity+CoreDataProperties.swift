//
//  TrainingSessionEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 14/06/2025.
//
//

import Foundation
import CoreData


extension TrainingSessionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingSessionEntity> {
        return NSFetchRequest<TrainingSessionEntity>(entityName: "TrainingSessionEntity")
    }

    @NSManaged public var calories: Int16
    @NSManaged public var countExercise: Int16
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var durationMinutes: Int16
    @NSManaged public var foto: String?
    @NSManaged public var id: UUID?
    @NSManaged public var muscleName: String?
    @NSManaged public var exercises: NSSet?
    @NSManaged public var isFinished: Bool

}

// MARK: Generated accessors for exercises
extension TrainingSessionEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

