//
//  Main.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//


import SwiftUI
import SwiftData

@main
struct SalsaLogApp: App {
   var sharedModelContainer: ModelContainer = {
       let schema = Schema([
           Venue.self,
           VenueReview.self,
           UserProfile.self
           // Event.self and Fitting.self go here once they're built
       ])
       let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

       do {
           return try ModelContainer(for: schema, configurations: [config])
       } catch {
           fatalError("Could not create ModelContainer: \(error)")
       }
   }()

   var body: some Scene {
       WindowGroup {
           MainTabView()
               .onAppear {
                   SeedData.seedIfNeeded(context: sharedModelContainer.mainContext)
               }
       }
       .modelContainer(sharedModelContainer)
   }
}
