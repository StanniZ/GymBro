//
//  TodaySessionViewModel.swift
//  GymBro
//
//  Created by macbook on 21/06/2025.
//
import SwiftUI
import Combine

// ViewModel для работы с тренировкой на сегодня
@MainActor
final class TodaySessionViewModel: ObservableObject {
    
    enum SaveState: Equatable{ case ready, saving, saved, failed(String)}
    
    // Текущая редактируемая (копия) тренировки для UI
    @Published var draftSession: TrainingSessionModel
    // Состояние сессии
    @Published var state: SaveState = .ready
    
    // Провайдер данных (инъекция зависимости, любой источник)
    private let provider: TodaysSessionProviderProtocol
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Инициализация ViewModel
    init(provider: TodaysSessionProviderProtocol, currentSessionProvider: CurrentSessionProvider) {
        self.provider = provider                           // сохраняем источник данных
        if let template = provider.fetchTodaysSession() {
            self.draftSession = template
        } else {
            print("no template")
            self.draftSession = .empty
        }
        
        cancellable = currentSessionProvider.$currentSession
            .compactMap { $0 }
            .assign(to: \.draftSession, on: self)
    }
    
    // MARK: - Сохранить изменения пользователя и закончить текущую сессию
    func finishSession() {
        guard state == .ready else { return }
        withAnimation(.easeInOut(duration: 0.3)){
            state = .saving
        }
        Task{
            do{
                try await provider.finishTodaysSession(draftSession)
                withAnimation(.easeInOut(duration: 0.3)){
                    state = .saved
                }
            } catch {
                withAnimation(.easeInOut(duration: 0.3)){
                    state = .failed(error.localizedDescription)
                }
                print("error saving session: \(error)")
            }
        }
    }
}
