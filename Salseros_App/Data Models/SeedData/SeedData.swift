//
//  SeedData.swift
//  SalsaLog
//
// Inserts demo data for local development and first launch.
//

import Foundation
import SwiftData

@MainActor
enum SeedData {

    static func seedIfNeeded(context: ModelContext) {
        let profiles = (try? context.fetch(FetchDescriptor<UserProfile>())) ?? []
        let venues = (try? context.fetch(FetchDescriptor<Venue>())) ?? []
        let events = (try? context.fetch(FetchDescriptor<Event>())) ?? []

        _ = profiles.currentUser ?? makeUserProfile(in: context)

        let realVenues = seedRealVenues(from: venues, context: context)

        seedEventsAndFittingsIfNeeded(
            existingEvents: events,
            venues: realVenues,
            context: context
        )

        try? context.save()
    }

    static func makeUserProfile(in context: ModelContext) -> UserProfile {
        let profile = UserProfile(
            name: "Nico",
            role: .lead,
            preferredStyles: [.mamboOn2, .salsaOn1],
            joinDate: date(year: 2024, month: 1, day: 1),
            friendNames: ["Nadia", "Diego", "Sam"]
        )
        context.insert(profile)
        return profile
    }

    static func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = .current
        components.year = year
        components.month = month
        components.day = day

        return components.date ?? .now
    }
}
