//
//  NASA_APIApp.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//
// swiftlint:disable type_name

import SwiftUI

@main
struct NASA_APIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        setupTabBarAppearance()
    }
}

// MARK: UI
extension NASA_APIApp {
    private func setupTabBarAppearance() {
        let appearance: UITabBarAppearance = {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color("tabBarForeground").opacity(0.5))]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color("tabBarForeground").opacity(0.5))
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color("tabBarForeground"))]
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color("tabBarForeground"))
            return appearance
        }()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
