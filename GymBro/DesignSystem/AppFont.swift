//
//  AppFont.swift
//  GymBro
//
//  Created by macbook on 14/07/2026.
//
import SwiftUI

enum AppFont {
    
    static let largeTitle = Font.system(
        size: 34,
        weight: .bold,
        design: .rounded
    )
    
    static let title = Font.system(
        size: 28,
        weight: .bold,
        design: .rounded
    )
    
    static let headline = Font.system(
        size: 22,
        weight: .semibold
    )
    
    static let body = Font.system(
        size: 17,
        weight: .regular
    )
    
    static let subheadline = Font.system(
            size: 15,
            weight: .medium
        )

        static let caption = Font.system(
            size: 13,
            weight: .medium
        )
}
