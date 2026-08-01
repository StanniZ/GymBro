//
//  PlaySound.swift
//  GymBro
//
//  Created by macbook on 03/09/2025.
//
import SwiftUI
import AudioToolbox

final class PlaySound {
    static func playTickSound() {
            AudioServicesPlaySystemSound(1104)

        }
}
