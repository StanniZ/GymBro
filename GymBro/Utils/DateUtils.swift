//
//  DateUtils.swift
//  GymBro
//
//  Created by macbook on 01/06/2025.
//
import Foundation

extension Date {
    
    static func generateTwoWeeks(from date: Date = Date()) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: today) else {
            return []
        }
        
        return (0..<16).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
    }
}
