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
    
    func fetchTodaysSession() -> TrainingSessionModel? {
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
            _ = finished.toEntity(context: bgContext)
            
            try bgContext.save()
        }
    }
    
    
    func getAllFinishedSessions() async throws -> [TrainingSessionModel] {
        let ctx = context
        return try await ctx.perform {
            let req: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
            req.predicate = NSPredicate(format: "isFinished == YES")
            req.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let entities = try ctx.fetch(req)
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

