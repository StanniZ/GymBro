//
//  TrainingSessionEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
//

public import Foundation
public import CoreData


public typealias TrainingSessionEntityCoreDataPropertiesSet = NSSet

extension TrainingSessionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingSessionEntity> {
        return NSFetchRequest<TrainingSessionEntity>(entityName: "TrainingSessionEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var templateID: UUID?
    @NSManaged public var name: String?
    @NSManaged public var durationMinutes: Int16
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var calories: Int16
    @NSManaged public var startedAt: Date?
    @NSManaged public var finishedAt: Date?
    @NSManaged public var isFinished: Bool
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension TrainingSessionEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: SessionExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: SessionExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension TrainingSessionEntity : Identifiable {

}
