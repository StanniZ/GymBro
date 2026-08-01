//
//  TemplateExerciseEntity+CoreDataProperties.swift
//  GymBro
//
//  Created by macbook on 21/07/2026.
//
//

public import Foundation
public import CoreData


public typealias TemplateExerciseEntityCoreDataPropertiesSet = NSSet

extension TemplateExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemplateExerciseEntity> {
        return NSFetchRequest<TemplateExerciseEntity>(entityName: "TemplateExerciseEntity")
    }

    @NSManaged public var exerciseID: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var position: Int16
    @NSManaged public var reps: Int16
    @NSManaged public var setsCount: Int16
    @NSManaged public var template: WorkoutTemplateEntity?

}

extension TemplateExerciseEntity : Identifiable {

}
