//
//  Exercise.swift
//  GymBro
//
//  Created by macbook on 20/06/2025.
//

import SwiftUI

struct Exercise: Identifiable{
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
}
