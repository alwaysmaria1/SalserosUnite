//
//  SeedData+Venues.swift
//  SalsaLog
//
// Real venue seed data sourced from event flyers.
//

import SwiftData

extension SeedData {

    static func seedRealVenues(
        from venues: [Venue],
        context: ModelContext
    ) -> SeededVenues {
        let studioViva = venue(named: "Studio Viva! Rooftop Latin Social", from: venues, context: context) {
            Venue(name: "Studio Viva! Rooftop Latin Social", city: "Chicago", address: "")
        }
        let reventon = venue(named: "Reventón - Noche de Cumbia", from: venues, context: context) {
            Venue(name: "Reventón - Noche de Cumbia", city: "Chicago", address: "1854 S Blue Island Ave, Chicago, IL 60608")
        }
        let drinkNightclub = venue(named: "Drink Nightclub", from: venues, context: context) {
            Venue(name: "Drink Nightclub", city: "Chicago", address: "")
        }
        let oakStreetBeach = venue(named: "Salsa on Oak Street Beach", from: venues, context: context) {
            Venue(name: "Salsa on Oak Street Beach", city: "Chicago", address: "1001 N Lake Shore Dr, Chicago, IL 60611")
        }
        let moesCantina = venue(named: "Moe's Cantina", from: venues, context: context) {
            Venue(name: "Moe's Cantina", city: "Chicago", address: "155 W Kinzie St, Chicago, IL 60654")
        }
        let latinRhythms = venue(named: "Latin Rhythms", from: venues, context: context) {
            Venue(name: "Latin Rhythms", city: "Chicago", address: "210 N Racine Ave, Chicago, IL 60607")
        }
        let brunchConRitmo = venue(named: "Brunch Con Ritmo Carnivale", from: venues, context: context) {
            Venue(name: "Brunch Con Ritmo Carnivale", city: "Chicago", address: "")
        }
        let chicagoBachata = venue(named: "Chicago Bachata", from: venues, context: context) {
            Venue(name: "Chicago Bachata", city: "Chicago", address: "Dance Center Chicago, 2nd Floor, 3868 N Lincoln Ave, Chicago, IL 60613")
        }
        let sensualTuesdays = venue(named: "Sensual Tuesdays", from: venues, context: context) {
            Venue(name: "Sensual Tuesdays", city: "Des Plaines", address: "Balkanika Restaurant and Bar, 1414 E Oakton St, Des Plaines, IL 60018")
        }
        let bailaTuesdays = venue(named: "Baila Tuesdays", from: venues, context: context) {
            Venue(name: "Baila Tuesdays", city: "Chicago", address: "")
        }
        let humboldtParkHappyHour = venue(named: "Latin Dance Happy Hour in Humboldt Park", from: venues, context: context) {
            Venue(name: "Latin Dance Happy Hour in Humboldt Park", city: "Chicago", address: "Studio E, 2657 W Division St, Humboldt Park, Chicago, IL")
        }

        return SeededVenues(
            studioViva: studioViva,
            reventon: reventon,
            drinkNightclub: drinkNightclub,
            oakStreetBeach: oakStreetBeach,
            moesCantina: moesCantina,
            latinRhythms: latinRhythms,
            brunchConRitmo: brunchConRitmo,
            chicagoBachata: chicagoBachata,
            sensualTuesdays: sensualTuesdays,
            bailaTuesdays: bailaTuesdays,
            humboldtParkHappyHour: humboldtParkHappyHour
        )
    }

    static func venue(
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
}

struct SeededVenues {
    let studioViva: Venue
    let reventon: Venue
    let drinkNightclub: Venue
    let oakStreetBeach: Venue
    let moesCantina: Venue
    let latinRhythms: Venue
    let brunchConRitmo: Venue
    let chicagoBachata: Venue
    let sensualTuesdays: Venue
    let bailaTuesdays: Venue
    let humboldtParkHappyHour: Venue
}
