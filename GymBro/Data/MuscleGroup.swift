//
//  MuscleGroup.swift
//  GymBro
//
//  Created by macbook on 15/07/2026.
//
import SwiftUI

enum MuscleGroup: String, CaseIterable, Hashable, Codable {

    // Chest
    case chest

    // Shoulders
    case shoulderFront = "shoulder_front"
    case shoulderBack  = "shoulder_back"

    // Arms
    case biceps
    case triceps
    case forearm

    // Back
    case latissimusDorsi = "latissimus_dorsi"
    case trapezius
    case backLumbar = "back_lumbar"

    // Abs
    case absUpper  = "abs_upper"
    case absMiddle = "abs_middle"
    case absLower  = "abs_lower"
    case absLateral = "abs_lateral"

    // Glutes
    case gluteal

    // Legs
    case quadriceps
    case quadricepsInside = "quadriceps_inside"
    case bicepsFemoris = "biceps_femoris"
    case adductorLegs = "adductor_legs"
    case gastrocnemius

    /// Name of SVG asset in Assets
    var assetName: String { rawValue }
}

// MARK: - Muscle Category (broad groups for the exercise picker)

enum MuscleCategory: String, CaseIterable {
    case all       = "All"
    case chest     = "Chest"
    case shoulders = "Shoulders"
    case arms      = "Arms"
    case back      = "Back"
    case core      = "Core"
    case legs      = "Legs"
    case glutes    = "Glutes"

    var muscleGroups: [MuscleGroup] {
        switch self {
        case .all:       return MuscleGroup.allCases
        case .chest:     return [.chest]
        case .shoulders: return [.shoulderFront, .shoulderBack]
        case .arms:      return [.biceps, .triceps, .forearm]
        case .back:      return [.latissimusDorsi, .trapezius, .backLumbar]
        case .core:      return [.absUpper, .absMiddle, .absLower, .absLateral]
        case .legs:      return [.quadriceps, .quadricepsInside, .bicepsFemoris, .adductorLegs, .gastrocnemius]
        case .glutes:    return [.gluteal]
        }
    }

    var icon: String {
        switch self {
        case .all:       return "figure.strengthtraining.functional"
        case .chest:     return "figure.arms.open"
        case .shoulders: return "figure.roll"
        case .arms:      return "hand.raised.fill"
        case .back:      return "figure.cooldown"
        case .core:      return "figure.core.training"
        case .legs:      return "figure.run"
        case .glutes:    return "figure.walk"
        }
    }
}
