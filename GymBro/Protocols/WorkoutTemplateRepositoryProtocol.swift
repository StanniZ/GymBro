//
//  WorkoutTemplateRepositoryProtocol.swift
//  GymBro
//
import Foundation

protocol WorkoutTemplateRepositoryProtocol {
    func saveTemplate(_ template: WorkoutTemplateModel) async throws
    func loadUserTemplates() async throws -> [WorkoutTemplateModel]
    func deleteTemplate(with id: UUID) async throws
}
