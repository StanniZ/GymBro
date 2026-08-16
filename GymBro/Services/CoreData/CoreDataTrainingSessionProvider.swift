//
//  CoreDataTrainingSessionProvider.swift
//  GymBro
//
//  Created by macbook on 20/06/2025.
//

import CoreData
import Foundation
    

@MainActor
final class CoreDataTrainingSessionProvider: CoreDataTrainingSessionProtocol {

    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchUnfinishedSessions() throws -> [TrainingSessionModel] {
        let request: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFinished == N0")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrainingSessionEntity.id, ascending: true)]
        
        let entities = try context.fetch(request)
        return entities.map {
            TrainingSessionMapper.toModel($0)
        }
    }
    
}
