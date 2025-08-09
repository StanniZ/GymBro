//
//  Persistence.swift
//  GymBro
//
//  Created by macbook on 30/05/2025.
//
// PersistenceController управляет Core Data стеком приложения.
// Обеспечивает доступ к базе данных через singleton `shared`,
// поддерживает in-memory режим для Preview и тестов.

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    // MARK: - Предпросмотр с inMemory хранилищем
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Здесь можешь создать фейковые данные для Preview
        return result
    }()

    // MARK: - Контейнер Core Data
    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Инициализация
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GymBro")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Ошибка загрузки хранилища: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Сохранение изменений
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Ошибка сохранения: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

