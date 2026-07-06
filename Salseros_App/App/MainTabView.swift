//
//  MainTabView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
//
//  MainTabView.swift
//  SalsaLog
//
//  3 real tabs (Home, Plan, You) plus a floating circular Log button
//  on top, matching the raised center-button design. Log was never a
//  browsable screen — it opens the new-fitting form as a sheet.
//
//  The empty middle tab item below is a spacer: it reserves visual
//  space in the tab bar so Home/Plan/[gap]/You divide evenly into 4
//  slots, and the floating button sits centered over that gap.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
 
            PlanView()
                .tabItem { Label("Plan", systemImage: "calendar") }
 
            LogView()
                .tabItem { Label("Log", systemImage: "plus.circle.fill") }
 
            ProfileView()
                .tabItem { Label("You", systemImage: "person") }
        }
    }
}
