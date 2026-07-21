//
//  SeedData+Events.swift
//  SalsaLog
//
// Event and fitting seed data for the real venue set.
//

import SwiftData

extension SeedData {

    static func seedEventsAndFittingsIfNeeded(
        existingEvents: [Event],
        venues: SeededVenues,
        context: ModelContext
    ) {
        let lrDanceSocial = event(
            named: "LR Dance Social",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "LR Dance Social",
                venue: venues.latinRhythms,
                nextDate: date(year: 2026, month: 7, day: 25),
                cadenceLabel: "weekly",
                friendsGoing: ["Nadia", "Diego"],
                goingCount: 5,
                isRSVPed: true,
                isFavorite: true,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "",
                    hours: "9:00 PM - 1:00 AM",
                    classBefore: false,
                    ticketsNeeded: false,
                    servesAlcohol: false
                )
            )
        }

        let tropicalNightEvent = event(
            named: "Tropical Night",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Tropical Night",
                venue: venues.moesCantina,
                nextDate: date(year: 2026, month: 7, day: 23),
                cadenceLabel: "weekly",
                friendsGoing: ["Sam"],
                goingCount: 3,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "Tropical",
                    coverCharge: "",
                    hours: "8:30 PM - 2:00 AM",
                    classBefore: false,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let bailaWednesdaysEvent = event(
            named: "Baila Wednesdays",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Baila Wednesdays",
                venue: venues.drinkNightclub,
                nextDate: date(year: 2026, month: 7, day: 22),
                cadenceLabel: "weekly",
                friendsGoing: ["Nadia", "Diego", "Sam"],
                goingCount: 6,
                isRSVPed: true,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "Free before 9 PM",
                    hours: "8:30 PM - late",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let studioVivaEvent = event(
            named: "Studio Viva! Rooftop Latin Social",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Studio Viva! Rooftop Latin Social",
                venue: venues.studioViva,
                nextDate: date(year: 2026, month: 7, day: 24),
                cadenceLabel: "special",
                friendsGoing: ["Nadia"],
                goingCount: 4,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "Tropical",
                    coverCharge: "",
                    hours: "6:00 PM - 10:00 PM",
                    classBefore: true,
                    ticketsNeeded: true,
                    servesAlcohol: true
                )
            )
        }

        let reventonEvent = event(
            named: "Reventón - Noche de Cumbia",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Reventón - Noche de Cumbia",
                venue: venues.reventon,
                nextDate: date(year: 2026, month: 7, day: 26),
                cadenceLabel: "club night",
                friendsGoing: ["Diego", "Sam"],
                goingCount: 8,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "",
                    hours: "9:00 PM - close",
                    classBefore: false,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let oakStreetBeachEvent = event(
            named: "Salsa on Oak Street Beach",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Salsa on Oak Street Beach",
                venue: venues.oakStreetBeach,
                nextDate: date(year: 2026, month: 7, day: 27),
                cadenceLabel: "summer series",
                friendsGoing: ["Nadia", "Sam"],
                goingCount: 9,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "Beach casual",
                    coverCharge: "Free",
                    hours: "5:00 PM - 9:00 PM",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let brunchConRitmoEvent = event(
            named: "Brunch Con Ritmo Carnivale",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Brunch Con Ritmo Carnivale",
                venue: venues.brunchConRitmo,
                nextDate: date(year: 2026, month: 7, day: 26),
                cadenceLabel: "brunch social",
                friendsGoing: ["Nadia"],
                goingCount: 4,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "$70/person (3-course a la carte) or $50/person (2 complimentary drinks)",
                    hours: "11:00 AM - 3:00 PM",
                    classBefore: true,
                    ticketsNeeded: true,
                    servesAlcohol: true
                )
            )
        }

        let chicagoBachataEvent = event(
            named: "Chicago Bachata",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Chicago Bachata",
                venue: venues.chicagoBachata,
                nextDate: date(year: 2026, month: 7, day: 31),
                cadenceLabel: "specialty social",
                friendsGoing: ["Diego"],
                goingCount: 7,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "",
                    hours: "10:00 PM - 3:00 AM",
                    classBefore: false,
                    ticketsNeeded: true,
                    servesAlcohol: true
                )
            )
        }

        let sensualTuesdaysEvent = event(
            named: "Sensual Tuesdays",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Sensual Tuesdays",
                venue: venues.sensualTuesdays,
                nextDate: date(year: 2026, month: 7, day: 28),
                cadenceLabel: "weekly",
                friendsGoing: ["Sam"],
                goingCount: 3,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "$10",
                    hours: "8:00 PM - 12:00 AM",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let bailaTuesdaysEvent = event(
            named: "Baila Tuesdays",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Baila Tuesdays",
                venue: venues.bailaTuesdays,
                nextDate: date(year: 2026, month: 7, day: 28),
                cadenceLabel: "weekly",
                friendsGoing: ["Nadia", "Diego"],
                goingCount: 5,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "",
                    hours: "Door 9:00 PM",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: true
                )
            )
        }

        let humboldtParkHappyHourEvent = event(
            named: "Latin Dance Happy Hour in Humboldt Park",
            existingEvents: existingEvents,
            context: context
        ) {
            Event(
                name: "Latin Dance Happy Hour in Humboldt Park",
                venue: venues.humboldtParkHappyHour,
                nextDate: date(year: 2026, month: 7, day: 29),
                cadenceLabel: "community social",
                friendsGoing: ["Sam", "Nadia"],
                goingCount: 6,
                isRSVPed: false,
                eventMeasurements: EventMeasurements(
                    dressCode: "",
                    coverCharge: "Free with RSVP (donations of $15-25 encouraged)",
                    hours: "7:00 PM - 10:00 PM",
                    classBefore: true,
                    ticketsNeeded: false,
                    servesAlcohol: false
                )
            )
        }

        lrDanceSocial.difficulties = [.intermediate, .advanced]
        tropicalNightEvent.difficulties = [.beginner, .allWelcome]
        bailaWednesdaysEvent.difficulties = [.advanced]
        studioVivaEvent.difficulties = [.beginner, .intermediate]
        reventonEvent.difficulties = [.intermediate]
        oakStreetBeachEvent.difficulties = [.beginner, .allWelcome]
        brunchConRitmoEvent.difficulties = [.allWelcome]
        chicagoBachataEvent.difficulties = [.intermediate, .advanced]
        sensualTuesdaysEvent.difficulties = [.beginner]
        bailaTuesdaysEvent.difficulties = [.intermediate]
        humboldtParkHappyHourEvent.difficulties = [.beginner, .allWelcome]

        if !lrDanceSocial.fittings.contains(where: { $0.loggedByName == "Nadia" }) {
            context.insert(Fitting(
                date: lrDanceSocial.nextDate,
                event: lrDanceSocial,
                verdict: .toMeasure,
                vibeTags: [.clubbing],
                danceStylesTonight: [.mamboOn2, .salsaOn1],
                difficulties: [.intermediate, .advanced],
                note: "It was a bit crowded and hard to hear the music but there were some crazy talented people in the room",
                loggedByName: "Nadia"
            ))
        }

        if !tropicalNightEvent.fittings.contains(where: { $0.loggedByName == "Sam" }) {
            context.insert(Fitting(
                date: tropicalNightEvent.nextDate,
                event: tropicalNightEvent,
                verdict: .altered,
                vibeTags: [.clubbing],
                danceStylesTonight: [.salsaOn1, .bachata],
                difficulties: [.beginner, .allWelcome],
                note: "I wish they played more cumbia!!!",
                loggedByName: "Sam"
            ))
        }

        if !bailaWednesdaysEvent.fittings.contains(where: { $0.loggedByName == "Diego" }) {
            context.insert(Fitting(
                date: bailaWednesdaysEvent.nextDate,
                event: bailaWednesdaysEvent,
                verdict: .bespoke,
                vibeTags: [.clubbing, .formal],
                danceStylesTonight: [.salsaOn1, .bachata],
                difficulties: [.advanced],
                note: "It was a chance to dress up so it was a win",
                loggedByName: "Diego"
            ))
        }

        //Nico's own fittings – these fuel the profile's swatch book.
        if lrDanceSocial.currentUserFitting == nil {
            context.insert(Fitting(
                date: date(year: 2026, month: 6, day: 18),
                event: lrDanceSocial,
                verdict: .bespoke,
                vibeTags: [.clubbing],
                danceStylesTonight: [.mamboOn2, .salsaOn1],
                difficulties: [.intermediate],
                note: "Best night in months — floor was electric and I stayed till last song.",
                loggedByName: UserProfile.currentUserDisplayName
            ))
        }

        if tropicalNightEvent.currentUserFitting == nil {
            context.insert(Fitting(
                date: date(year: 2026, month: 7, day: 2),
                event: tropicalNightEvent,
                verdict: .toMeasure,
                vibeTags: [.clubbing],
                danceStylesTonight: [.salsaOn1, .bachata],
                difficulties: [.beginner, .intermediate],
                note: "Solid crowd, cream of the crop shows up on Wednesdays.",
                loggedByName: UserProfile.currentUserDisplayName
            ))
        }
    }

    static func event(
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
}
