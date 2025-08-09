//
//  DateUtils.swift
//  GymBro
//
//  Created by macbook on 01/06/2025.
//
import Foundation

struct DateUtils {
    
    static let calendar = Calendar.current
    
    static var currentWeekday: String {
        let formater = DateFormatter()
        formater.dateFormat = "EEEE"
        return formater.string(from: Date())
    }
    
    static func generatedDateOfMonth(from date: Date = Date()) -> [Date] {
        guard let firstDayOfMounth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        return range.compactMap{ day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMounth)
        }
    }
    
    static func generateFromCurrentDateToEndOfMonth(from date: Date = Date()) -> [Date] {
        let allDates = generatedDateOfMonth(from: date)
        return allDates.filter { date < $0}
    }
}
