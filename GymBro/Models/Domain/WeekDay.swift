//
//  WeekDay.swift
//  GymBro
//
//  Created by macbook on 01/06/2025.
//
import SwiftUI

struct WeekDay: Identifiable {
    
    let id = UUID()
    let date: Date
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
