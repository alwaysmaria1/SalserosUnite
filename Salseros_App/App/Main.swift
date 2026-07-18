//
//  Main.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// App entry point that sets up SwiftData and launches the main tabs.

import SwiftUI
import SwiftData
import UIKit

@main
struct SalsaLogApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Venue.self,
            UserProfile.self,
            Event.self,
            Fitting.self
        ])
        let storeURL = Self.storeURL()
        let config = ModelConfiguration("SalsaLog", schema: schema, url: storeURL)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            resetStore(at: storeURL)

            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Could not create ModelContainer after resetting local store: \(error)")
            }
        }
    }()

    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(Color.espresso)
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.ivory)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.ivory)]

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear {
                    SeedData.seedIfNeeded(context: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private static func storeURL() -> URL {
        let applicationSupportURL = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first ?? FileManager.default.temporaryDirectory
        let directoryURL = applicationSupportURL.appendingPathComponent("SalsaLog", isDirectory: true)

        try? FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        return directoryURL.appendingPathComponent("SalsaLog.store")
    }

    private static func resetStore(at storeURL: URL) {
        let fileURLs = [
            storeURL,
            storeURL.deletingLastPathComponent().appendingPathComponent("\(storeURL.lastPathComponent)-shm"),
            storeURL.deletingLastPathComponent().appendingPathComponent("\(storeURL.lastPathComponent)-wal")
        ]

        for fileURL in fileURLs {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}
