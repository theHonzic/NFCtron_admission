//
//  ContentView.swift
//  NASA API
//
//  Created by Jan Janovec on 08.04.2023.
//

import SwiftUI

struct ContentView: View {
    private enum Tab {
        case daily, launches
    }
    @State private var selectedTab: Tab = .daily
    var body: some View {
        TabView(selection: $selectedTab) {
            DailyView()
                .tabItem {
                    Label("Daily", systemImage: "picture")
                }.tag(Tab.daily)
            LaunchesView()
                .tabItem {
                    Label("Launches", systemImage: "calendar")
                }.tag(Tab.launches)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
