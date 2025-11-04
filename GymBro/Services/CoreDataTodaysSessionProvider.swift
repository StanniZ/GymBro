//
//  CoreDataTodaysSessionProvider.swift
//  GymBro
//
//  Created by macbook on 22/06/2025.
//
import CoreData
import Foundation

final class CoreDataTodaysSessionProvider: TodaysSessionProviderProtocol, StatisticsProtocol {
    
    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer
    
    init(context: NSManagedObjectContext, container: NSPersistentContainer) {
        self.container = container
        self.context = context
    }
    
    func fetchTodaysSession() -> TrainingSessionModel? {
        let today = DateHelper.getCurrentWeekDay()
        let request: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
        let dayPredicate = NSPredicate(format: "dayOfWeek == %@", today)
        let notFinishedSessionPredicate = NSPredicate(format: "isFinished == NO")
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, notFinishedSessionPredicate])
        request.fetchLimit = 1
        let results = try? context.fetch(request)
        print("Session found:", results?.count ?? 0)
        
        do {
            if let entity = try context.fetch(request).first {
                return entity.toModel()
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func saveTodaysSession(_ session: TrainingSessionModel) async throws {
        
    }
    
    func finishTodaysSession(_ session: TrainingSessionModel) async throws {
        let bgContext = container.newBackgroundContext()
        try await bgContext.perform{
            var finished = session
            finished.id = UUID()
            finished.isFinished = true
            finished.timestamp = Date()
            _ = finished.toEntity(context: bgContext)
            
            try bgContext.save()
        }
    }
    
    
    func getAllFinishedSessions() async throws -> [TrainingSessionModel] {
        try await context.perform {
            let req: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
            req.predicate = NSPredicate(format: "isFinished == YES")
            req.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let entities = try self.context.fetch(req)
            return entities.map { $0.toModel() }
        }
    }
    
    func deleteSession(with id: UUID) async throws {
        let bg = container.newBackgroundContext()
        try await bg.perform {
            let req: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
            req.fetchLimit = 1
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            guard let entity = try bg.fetch(req).first else {
                throw NSError(domain: "Delete", code: 404, userInfo: [NSLocalizedDescriptionKey: "Session not found"])
            }
            
            bg.delete(entity)
            try bg.save()
        }
    }
}

