//
//  CoreDataSeeder.swift
//  GymBro
//
//  Created by macbook on 14/06/2025.
//

import Foundation
import CoreData

struct CoreDataSeeder {
    
    static let shared = CoreDataSeeder()
    private var context = PersistenceController.shared.context
    
    private init() {}
    
    func seedInitialSessionIfNeeded() {
        // Получаем уже существующие дни
        let allReq: NSFetchRequest<TrainingSessionEntity> = TrainingSessionEntity.fetchRequest()
        let existingDays = (try? context.fetch(allReq))?
            .compactMap { $0.dayOfWeek } ?? []
        
        let templates = DataGridBuildSession.getBuildSession()
        // Отбираем шаблоны, которых ещё нет в базе
        let missing = templates.filter { !existingDays.contains($0.dayOfWeek) }
        guard !missing.isEmpty else { return }
        
        // Добавляем недостающие
        for template in missing {
            _ = template.toEntity(context: context)
        }
        try? context.save()
    }
    
//    func deleteAllSession() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TrainingSessionEntity.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        _ = try? context.execute(deleteRequest)
//        print("all session deleted")
//    }
}
