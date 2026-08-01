//
//  CoreDataWorkoutTemplateRepository.swift
//  GymBro
//
import CoreData

final class CoreDataWorkoutTemplateRepository: WorkoutTemplateRepositoryProtocol {

    private let context: NSManagedObjectContext
    private let container: NSPersistentContainer

    init(context: NSManagedObjectContext, container: NSPersistentContainer) {
        self.context = context
        self.container = container
    }

    func saveTemplate(_ template: WorkoutTemplateModel) async throws {
        let bg = container.newBackgroundContext()
        try await bg.perform {
            _ = WorkoutTemplateMapper.toEntity(template, context: bg)
            try bg.save()
        }
    }

    func loadUserTemplates() async throws -> [WorkoutTemplateModel] {
        let ctx = context
        return try await ctx.perform {
            let req: NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(keyPath: \WorkoutTemplateEntity.createdAt, ascending: false)]
            return try ctx.fetch(req).map { WorkoutTemplateMapper.toModel($0) }
        }
    }

    func deleteTemplate(with id: UUID) async throws {
        let bg = container.newBackgroundContext()
        try await bg.perform {
            let req: NSFetchRequest<WorkoutTemplateEntity> = WorkoutTemplateEntity.fetchRequest()
            req.fetchLimit = 1
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            guard let entity = try bg.fetch(req).first else {
                throw NSError(domain: "Delete", code: 404, userInfo: nil)
            }
            bg.delete(entity)
            try bg.save()
        }
    }
}
