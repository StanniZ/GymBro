//
//  DataHelper.swift
//  GymBro
//
//  Created by macbook on 22/06/2025.
//
import Foundation

final class DateHelper {
    
    static func getCurrentWeekDay() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}
