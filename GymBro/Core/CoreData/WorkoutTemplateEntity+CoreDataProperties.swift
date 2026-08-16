//
//  WorkoutTemplateEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
//

public import Foundation
public import CoreData


public typealias WorkoutTemplateEntityCoreDataPropertiesSet = NSSet

extension WorkoutTemplateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutTemplateEntity> {
        return NSFetchRequest<WorkoutTemplateEntity>(entityName: "WorkoutTemplateEntity")
    }

    @NSManaged public var calories: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var dayOfWeek: String?
    @NSManaged public var durationMinutes: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var exercises: NSSet?

}

// MARK: Generated accessors for exercises
extension WorkoutTemplateEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: TemplateExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: TemplateExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension WorkoutTemplateEntity : Identifiable {

}
