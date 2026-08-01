//
//  SessionExerciseEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
//

public import Foundation
public import CoreData


public typealias SessionExerciseEntityCoreDataPropertiesSet = NSSet

extension SessionExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionExerciseEntity> {
        return NSFetchRequest<SessionExerciseEntity>(entityName: "SessionExerciseEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var exerciseID: Int64
    @NSManaged public var position: Int16
    @NSManaged public var session: TrainingSessionEntity?
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for sets
extension SessionExerciseEntity {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: ExerciseSetEntity)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: ExerciseSetEntity)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension SessionExerciseEntity : Identifiable {

}
