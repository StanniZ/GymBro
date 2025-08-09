//
//  CoreDataTrainingSessionProvider.swift
//  GymBro
//
//  Created by macbook on 20/06/2025.
//

import CoreData
import Foundation

final class CoreDataTrainingSessionProvider: BuildSessionProviderProtocol {
    // Контекст Core Data, через который выполняются операции
    private let context: NSManagedObjectContext
    
    // Инициализатор. По умолчанию использует контекст из синглтона PersistenceController
    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }
    
    func fetchSessions() -> [TrainingSessionModel] {
        let request: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFinished == false")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TrainingSessionEntity.dayOfWeek, ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map {$0.toModel()}
        } catch {
            print("Failed return sessions: \(error)")
            return []
        }
    }
    
}
