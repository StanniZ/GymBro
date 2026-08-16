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

            .init(header: "Account", items: [
                .navigation(.init(
                    title: "My Account",
                    icon: "person.fill",
                    iconColor: .accent,
                    destination: .account
                )),
                .navigation(.init(
                    title: "My Goals",
                    icon: "target",
                    iconColor: .orange,
                    destination: .goals
                ))
            ]),

            .init(header: "Preferences", items: [
                .toggle(.init(
                    title: "Notifications",
                    icon: "bell.badge.fill",
                    iconColor: .purple,
                    key: .notifications
                )),
                .navigation(.init(
                    title: "Weight Unit",
                    icon: "scalemass.fill",
                    iconColor: .blue,
                    destination: .weightUnit
                )),
                .navigation(.init(
                    title: "Apple Health",
                    icon: "heart.fill",
                    iconColor: .red,
                    destination: .appleHealth
                ))
            ]),

            .init(header: "General", items: [
                .navigation(.init(
                    title: "Help & Support",
                    icon: "questionmark.circle.fill",
                    iconColor: .teal,
                    destination: .support
                )),
                .navigation(.init(
                    title: "Log Out",
                    icon: "rectangle.portrait.and.arrow.right",
                    iconColor: .red,
                    destination: .logout
                ))
            ])
        ])
    }
}
