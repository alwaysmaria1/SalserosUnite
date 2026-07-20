//
//  SeedData.swift
//  SalsaLog
//
//  Inserts placeholder demo content so there's something to look at before
//  the logging UI exists. The seeding is intentionally idempotent: if an
//  earlier app version already inserted profiles, venues, or events, later
//  seed passes can still add newly introduced records without duplicating
//  existing data.
//
// Inserts demo data for local development and first launch.

import Foundation
import SwiftData

@MainActor
enum SeedData {

    static func seedIfNeeded(context: ModelContext) {
        let profiles = (try? context.fetch(FetchDescriptor<UserProfile>())) ?? []
        let venues = (try? context.fetch(FetchDescriptor<Venue>())) ?? []
        let events = (try? context.fetch(FetchDescriptor<Event>())) ?? []

        _ = profiles.first ?? makeUserProfile(in: context)
        let mamboCity = venue(named: "Mambo City", from: venues, context: context) {
            Venue(name: "Mambo City", city: "Chicago", address: "123 W Example St, Avondale")
        }
        let miSalsaKitchen = venue(named: "Mi Salsa Kitchen", from: venues, context: context) {
            Venue(name: "Mi Salsa Kitchen", city: "Chicago", address: "456 N Example Ave, Logan Square")
        }
        let vidaLoca = venue(named: "Vida Loca Thursdays", from: venues, context: context) {
            Venue(name: "Vida Loca Thursdays", city: "Chicago", address: "789 S Example Blvd, Pilsen")
        }

        seedEventsAndFittingsIfNeeded(
            existingEvents: events,
            mamboCity: mamboCity,
            miSalsaKitchen: miSalsaKitchen,
            vidaLoca: vidaLoca,
            context: context
        )

        try? context.save()
    }

    private static func makeUserProfile(in context: ModelContext) -> UserProfile {
        let profile = UserProfile(
            name: "Noe",
            preferredStyles: [.mamboOn2, .salsaOn1],
            friendNames: ["Marisol", "Diego", "Sam"]
        )
        context.insert(profile)
        return profile
    }

    private static func venue(
        named name: String,
        from venues: [Venue],
        context: ModelContext,
        makeVenue: () -> Venue
    ) -> Venue {
        if let existingVenue = venues.first(where: { $0.name == name }) {
            return existingVenue
        }

        let newVenue = makeVenue()
        context.insert(newVenue)
        return newVenue
    }

    private static func seedEventsAndFittingsIfNeeded(
        existingEvents: [Event],
        mamboCity: Venue,
        miSalsaKitchen: Venue,
        vidaLoca: Venue,
        context: ModelContext
    ) {
        let calendar = Calendar.current
        let today = Date.now
        let nextFriday = calendar.date(byAdding: .day, value: 4, to: today) ?? today
        let nextSunday = calendar.date(byAdding: .day, value: 6, to: today) ?? today

        let mamboCityEvent = event(
            named: "Latin Rhythms Biweekly",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Latin Rhythms Biweekly",
                venue: mamboCity,
                nextDate: today,
                cadenceLabel: "biweekly",
                friendsGoing: ["Marisol", "Diego", "Sam"],
                goingCount: 7,
                isRSVPed: true,
                isFavorite: true,
                eventMeasurements: EventMeasurements(
                    dressCode: "Sharp, two-tone shoes recommended",
                    coverCharge: "$10 before 9, $15 after",
                    hours: "9PM - 2AM",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let practicaEvent = event(
            named: "Sunday Practica",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Sunday Practica",
                venue: miSalsaKitchen,
                nextDate: nextSunday,
                cadenceLabel: "weekly",
                friendsGoing: [],
                goingCount: 3,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "Relaxed, come as you are",
                    coverCharge: "Free",
                    hours: "8PM - 12AM",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: false
                )
            )
        }

        let vidaLocaEvent = event(
            named: "Palladium Night - live orquesta",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Palladium Night - live orquesta",
                venue: vidaLoca,
                nextDate: nextFriday,
                cadenceLabel: "monthly",
                friendsGoing: ["Marisol"],
                goingCount: 1,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "Dressy, no sneakers",
                    coverCharge: "$20",
                    hours: "10PM - 3AM",
                    classBefore: false,
                    ticketsNeeded: true,
                    servesAlcohol: true
                )
            )
        }

        seedFittingIfNeeded(
            for: mamboCityEvent,
            loggedByName: "You",
            context: context,
            verdict: .bespoke,
            vibeTags: [.clubbing],
            danceStylesTonight: [.mamboOn2],
            difficulties: [.intermediate, .advanced],
            leadFollowRatio: .balanced,
            note: "Floor runs fast after 11. Great On2 room."
        )
        seedFittingIfNeeded(
            for: mamboCityEvent,
            loggedByName: "Marisol",
            context: context,
            verdict: .toMeasure,
            vibeTags: [.clubbing],
            danceStylesTonight: [.mamboOn2, .salsaOn1],
            difficulties: [.advanced],
            leadFollowRatio: .moreLeads,
            note: "Best On2 floor below 14th. Get there before the band starts."
        )
        seedFittingIfNeeded(
            for: practicaEvent,
            loggedByName: "You",
            context: context,
            verdict: .altered,
            vibeTags: [.indoors],
            danceStylesTonight: [.salsaOn1, .bachata],
            difficulties: [.beginner, .intermediate],
            leadFollowRatio: .balanced,
            note: "Good for a quiet night, easy to get asked to dance."
        )
        seedFittingIfNeeded(
            for: practicaEvent,
            loggedByName: "Diego",
            context: context,
            verdict: .rack,
            vibeTags: [.indoors],
            danceStylesTonight: [.salsaOn1],
            difficulties: [.beginner],
            leadFollowRatio: .moreFollows,
            note: "Chill spot, good for practicing basics."
        )
        seedFittingIfNeeded(
            for: vidaLocaEvent,
            loggedByName: "You",
            context: context,
            verdict: .bespoke,
            vibeTags: [.outdoors],
            danceStylesTonight: [.salsaOn1, .cumbia],
            difficulties: [.advanced],
            leadFollowRatio: .moreLeads,
            note: "Serious dancers only. Bring your A-game."
        )
        seedFittingIfNeeded(
            for: vidaLocaEvent,
            loggedByName: "Sam",
            context: context,
            verdict: .toMeasure,
            vibeTags: [.indoors],
            danceStylesTonight: [.salsaOn1],
            difficulties: [.advanced],
            leadFollowRatio: .balanced,
            note: "Tickets sell out - buy early."
        )
    }

    private static func event(
        named name: String,
        existingEvents: [Event],
        context: ModelContext,
        makeEvent: () -> Event
    ) -> Event {
        if let existingEvent = existingEvents.first(where: { $0.name == name }) {
            return existingEvent
        }

        let newEvent = makeEvent()
        context.insert(newEvent)
        return newEvent
    }

    private static func seedFittingIfNeeded(
        for event: Event,
        loggedByName: String,
        context: ModelContext,
        verdict: Verdict,
        vibeTags: Set<Vibe>,
        danceStylesTonight: Set<DanceStyle>,
        difficulties: Set<Difficulty>,
        leadFollowRatio: LeadFollowRatio,
        note: String
    ) {
        guard !event.fittings.contains(where: { $0.loggedByName == loggedByName }) else { return }

        let fitting = Fitting(
            date: event.nextDate,
            event: event,
            verdict: verdict,
            vibeTags: vibeTags,
            danceStylesTonight: danceStylesTonight,
            difficulties: difficulties,
            leadFollowRatio: leadFollowRatio,
            note: note,
            loggedByName: loggedByName
        )
        context.insert(fitting)
    }
}
