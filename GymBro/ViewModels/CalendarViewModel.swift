//
//  CalendarViewModel.swift
//  GymBro
//
//  Created by macbook on 02/10/2025.
//
import SwiftUI

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var completedSessions: Set<Date> = []
    
    private let calendar = Calendar.current
    private let provider: StatisticsProtocol
    
    init(provider: StatisticsProtocol) {
        self.provider = provider
        Task { @MainActor in
            await self.loadCompletedSessions()
        }
    }
    
    func loadCompletedSessions() async {
        do {
            let sessions = try await provider.getAllFinishedSessions()
            completedSessions = Set(sessions.compactMap { session in
                guard let date = session.timestamp as Date? else { return nil }
                return calendar.startOfDay(for: date)
                
            })

        } catch {
            completedSessions = []
        }
    }
    
    func isCompleted(_ date: Date) -> Bool {
        return completedSessions.contains(where: {calendar.isDate($0, inSameDayAs: date)})
    }
}
