//
//  BuiltInTemplatesViewModel.swift
//  GymBro
//
import SwiftUI

enum TemplateFilter: String, CaseIterable {
    case recent = "Recent"
    case my = "My"
    case builtIn = "Built-In"
}

final class BuiltInTemplatesViewModel: ObservableObject {

    @Published var selectedFilter: TemplateFilter = .builtIn
    @Published private(set) var userTemplates: [WorkoutTemplateModel] = []
    @Published private(set) var recentTemplates: [WorkoutTemplateModel] = []

    private let builtInTemplates: [WorkoutTemplateModel]
    private let currentSessionProvider: CurrentSessionManager
    private let templateRepository: WorkoutTemplateRepositoryProtocol
    private let sessionProvider: WorkoutSessionProviderProtocol

    var displayedTemplates: [WorkoutTemplateModel] {
        switch selectedFilter {
        case .recent:  return recentTemplates
        case .my:      return userTemplates
        case .builtIn: return builtInTemplates
        }
    }

    init(
        currentSessionProvider: CurrentSessionManager,
        templateRepository: WorkoutTemplateRepositoryProtocol,
        sessionProvider: WorkoutSessionProviderProtocol
    ) {
        self.builtInTemplates = BuiltInWorkoutTemplates.getBuildSession()
        self.currentSessionProvider = currentSessionProvider
        self.templateRepository = templateRepository
        self.sessionProvider = sessionProvider
    }

    func didSelectTemplate(_ template: WorkoutTemplateModel) {
        let session = template.makeTrainingSession()
        currentSessionProvider.setCurrentSession(session)
    }

    func loadData() {
        Task { @MainActor in
            await loadUserTemplates()
            await loadRecentTemplates()
        }
    }

    @MainActor
    private func loadUserTemplates() async {
        guard let templates = try? await templateRepository.loadUserTemplates() else { return }
        userTemplates = templates
    }

    @MainActor
    private func loadRecentTemplates() async {
        guard let sessions = try? await sessionProvider.getAllFinishedSessions() else { return }
        recentTemplates = sessions
            .sorted { ($0.finishedAt ?? .distantPast) > ($1.finishedAt ?? .distantPast) }
            .prefix(5)
            .map { $0.asTemplate() }
    }

    func saveUserTemplate(_ template: WorkoutTemplateModel) {
        Task { @MainActor in
            try? await templateRepository.saveTemplate(template)
            await loadUserTemplates()
        }
    }

    func deleteUserTemplate(with id: UUID) {
        userTemplates.removeAll { $0.id == id }
        Task {
            try? await templateRepository.deleteTemplate(with: id)
        }
    }
}
