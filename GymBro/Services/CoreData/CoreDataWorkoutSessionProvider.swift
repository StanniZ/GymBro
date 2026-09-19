//
//  CoreDataTodaysSessionProvider.swift
//  GymBro
//
//  Created by macbook on 22/06/2025.
//
import CoreData
import Foundation

final class CoreDataWorkoutSessionProvider: WorkoutSessionProviderProtocol, StatisticsProtocol {
    
    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer
    
    init(context: NSManagedObjectContext, container: NSPersistentContainer) {
        self.container = container
        self.context = context
    }
    
    func saveTodaysSession(_ session: TrainingSessionModel) async throws {
        
    }
    
    func finishTodaysSession(_ session: TrainingSessionModel) async throws {
        let bgContext = container.newBackgroundContext()
        try await bgContext.perform{
            var finished = session
            finished.id = UUID()
            finished.isFinished = true
            finished.finishedAt = Date()
            _ = TrainingSessionMapper.toEntity(finished, context: bgContext)
            
            try bgContext.save()
        }
    }

    func saveFinishedSession(_ session: TrainingSessionModel) async throws {
        let bgContext = container.newBackgroundContext()
        try await bgContext.perform {
            let request: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)

            if let existing = try bgContext.fetch(request).first {
                bgContext.delete(existing)
            }

            var finished = session
            finished.isFinished = true
            if finished.finishedAt == nil {
                finished.finishedAt = Date()
            }

            _ = TrainingSessionMapper.toEntity(finished, context: bgContext)
            try bgContext.save()
        }
    }
    
    
    func getAllFinishedSessions() async throws -> [TrainingSessionModel] {
        let ctx = context
        return try await ctx.perform {
            let req: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
            req.predicate = NSPredicate(format: "isFinished == YES")
            req.sortDescriptors = [NSSortDescriptor(keyPath: \TrainingSessionEntity.finishedAt, ascending: true)]
            let entities = try ctx.fetch(req)
            return entities.map {
                TrainingSessionMapper.toModel($0)
            }
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
