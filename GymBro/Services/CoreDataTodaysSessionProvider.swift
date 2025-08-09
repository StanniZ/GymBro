//
//  CoreDataTodaysSessionProvider.swift
//  GymBro
//
//  Created by macbook on 22/06/2025.
//
import CoreData
import Foundation

final class CoreDataTodaysSessionProvider: TodaysSessionProviderProtocol {
    
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
            let entity = session.toEntity(context: bgContext)
            entity.isFinished = true
            if bgContext.hasChanges {
                try bgContext.save()
                print("session saved")
                self.fetchFinishedSessions()
            }
        }
    }
    
    func fetchFinishedSessions() {
        let request: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFinished == YES")
        do{
            let results = try context.fetch(request)
            print("Finished sessions:", results.count)
            for session in results {
                print("\(session.muscleName ?? "No muscle name"), \(session.calories)")
                
                if let exercises = session.exercises as? Set<ExerciseEntity>{
                    for exercise in exercises {
                        print("\(exercise.name ?? "No exercise name")")
                        
                        if let sets = exercise.sets as? Set<ExerciseSetEntity>{
                            let sortedSets = sets.sorted {
                                ($0.timestamp ?? Date.distantPast) > ($1.timestamp ?? Date.distantPast)
                            }
                            for (index, exerciseSet) in sortedSets.enumerated() {
                                print("Set \(index+1). \(exerciseSet.reps) reps, \(exerciseSet.weightKg) kg")
                            }
                        } else {
                            print( "No sets found")
                        }
                    }
                } else {
                    print( "No exercises found")
                }
            }
        } catch {
            print("error fetching finished sessions: \(error)")
        }
        
    }
}
