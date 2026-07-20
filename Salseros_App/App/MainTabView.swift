//
//  MainTabView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Main tab navigation for the app.

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                onLogNight: { selectedTab = .search },
                onPlan: { selectedTab = .plan }
            )
                .tabItem { Label("Home", systemImage: "house") }
                .tag(AppTab.home)

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(AppTab.search)

            PlanView()
                .tabItem { Label("Plan", systemImage: "calendar") }
                .tag(AppTab.plan)

//            LogView()
//                .tabItem { Label("Log", systemImage: "plus.circle.fill") }

            ProfileView()
                .tabItem { Label("You", systemImage: "person") }
                .tag(AppTab.profile)
        }
        .tint(Color.ivory)
    }
}

private enum AppTab {
    case search
    case plan
    case home
    case profile
}
