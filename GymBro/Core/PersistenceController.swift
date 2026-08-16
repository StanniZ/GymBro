//
//  PersistenceController.swift
//  GymBro
//
//  Created by macbook on 19/07/2026.
//
import CoreData


struct PersistenceController {
    
    static let shared = PersistenceController()
    static let preview: PersistenceController = {
        PersistenceController(inMemory: true)
    }()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WorkoutData")
        
        if inMemory {
            container
                .persistentStoreDescriptions
                .first?
                .type = NSInMemoryStoreType
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
        
        container.viewContext
                .automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy =
            NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() throws {
        let context = container.viewContext
        
        guard context.hasChanges else { return }
        
        try context.save()
    }
}
