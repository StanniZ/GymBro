//
//  SettingsConfigurationBuilder.swift
//  GymBro
//
//  Created by macbook on 01/02/2026.
//
import SwiftUI

struct SettingsConfigurationBuilder {
    
    static func build() -> SettingsConfiguration {
        SettingsConfiguration(sections: [
            
            //Account
            .init(items: [
                .navigation(.init(
                    title: "My account",
                    icon: "person",
                    destination: .account
                )),
                .navigation(.init(
                    title: "My goals",
                    icon: "line.3.crossed.swirl.circle",
                    destination: .goals
                ))
            ]),
            
            //Preferences
            .init(items: [
                .toggle(.init(
                    title: "Notification",
                    icon: "bell.badge",
                    key: .notifications
                )),
                .toggle(.init(
                    title: "Dark mode",
                    icon: "moon",
                    key: .darkMode
                )),
                .navigation(.init(
                    title: "Weight unit",
                    icon: "scalemass",
                    destination: .weightUnit
                ))
            ]),
            
            //Other
            .init(items: [
                .navigation(.init(
                    title: "Workout history",
                    icon: "magazine",
                    destination: .workoutHistory
                )),
                .navigation(.init(
                    title: "Help & Support",
                    icon: "point.3.connected.trianglepath.dotted",
                    destination: .support
                )),
                .navigation(.init(
                    title: "Log out",
                    icon: "rectangle.portrait.and.arrow.right",
                    destination: .logout
                ))
            ])
        ])
    }
}
