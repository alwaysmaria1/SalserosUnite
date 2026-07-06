//
//  SeedData.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//

//
//  SeedData.swift
//  SalsaLog
//
//  Inserts placeholder demo content the first time the app launches,
//  so there's something to look at before the logging UI exists.
//  Placeholder names/venues only — Day 18 of the plan swaps these for
//  your real Chicago venues and real friend quotes.
//
//  Call SeedData.seedIfNeeded(context:) once, right after your
//  ModelContainer is created in the App file.
//

import Foundation
import SwiftData

enum SeedData {

    static func seedIfNeeded(context: ModelContext) {
        // Guard: only seed once. If a UserProfile already exists, assume
        // seeding already happened (either by us, or by real user data).
        let existingProfiles = try? context.fetch(FetchDescriptor<UserProfile>())
        guard (existingProfiles?.isEmpty ?? true) else { return }

        // MARK: - Your profile

        let me = UserProfile(
            name: "Noe",
            preferredStyles: [.mamboOn2, .salsaOn1],
            friendNames: ["Marisol", "Diego", "Sam"]
        )
        context.insert(me)

        // MARK: - Venue 1

        let mamboCity = Venue(
            name: "Mambo City",
            city: "Chicago",
            address: "123 W Example St, Avondale",
            isStandingOrder: true,
            measurements: Measurements(
                dressCode: "Sharp, two-tone shoes recommended",
                coverCharge: "$10 before 9, $15 after",
                hours: "9PM – 2AM",
                classBefore: true,
                ticketsNeeded: false,
                servesAlcohol: true
            ),
            owner: me
        )
        context.insert(mamboCity)

        let mamboCityReviews = [
            VenueReview(
                reviewerName: "You",
                venue: mamboCity,
                energy: .clubbing,
                danceStyles: [.mamboOn2],
                difficulties: [.intermediate, .advanced],
                leadFollowRatio: .balanced,
                comment: "Floor runs fast after 11. Great On2 room."
            ),
            VenueReview(
                reviewerName: "Marisol",
                venue: mamboCity,
                energy: .clubbing,
                danceStyles: [.mamboOn2, .salsaOn1],
                difficulties: [.advanced],
                leadFollowRatio: .moreLeads,
                comment: "Best On2 floor below 14th. Get there before the band starts."
            )
        ]
        mamboCityReviews.forEach { context.insert($0) }

        // MARK: - Venue 2

        let miSalsaKitchen = Venue(
            name: "Mi Salsa Kitchen",
            city: "Chicago",
            address: "456 N Example Ave, Logan Square",
            isStandingOrder: false,
            measurements: Measurements(
                dressCode: "Casual, come as you are",
                coverCharge: "Free",
                hours: "8PM – 12AM",
                classBefore: true,
                ticketsNeeded: false,
                servesAlcohol: false
            ),
            owner: me
        )
        context.insert(miSalsaKitchen)

        let miSalsaKitchenReviews = [
            VenueReview(
                reviewerName: "You",
                venue: miSalsaKitchen,
                energy: .casual,
                danceStyles: [.salsaOn1, .bachata],
                difficulties: [.beginner, .intermediate],
                leadFollowRatio: .balanced,
                comment: "Good for a quiet night, easy to get asked to dance."
            ),
            VenueReview(
                reviewerName: "Diego",
                venue: miSalsaKitchen,
                energy: .casual,
                danceStyles: [.salsaOn1],
                difficulties: [.beginner],
                leadFollowRatio: .moreFollows,
                comment: "Chill spot, good for practicing basics."
            )
        ]
        miSalsaKitchenReviews.forEach { context.insert($0) }

        // MARK: - Venue 3

        let vidaLoca = Venue(
            name: "Vida Loca Thursdays",
            city: "Chicago",
            address: "789 S Example Blvd, Pilsen",
            isStandingOrder: false,
            measurements: Measurements(
                dressCode: "Dressy, no sneakers",
                coverCharge: "$20",
                hours: "10PM – 3AM",
                classBefore: false,
                ticketsNeeded: true,
                servesAlcohol: true
            ),
            owner: me
        )
        context.insert(vidaLoca)

        let vidaLocaReviews = [
            VenueReview(
                reviewerName: "You",
                venue: vidaLoca,
                energy: .competition,
                danceStyles: [.salsaOn1, .cumbia],
                difficulties: [.advanced],
                leadFollowRatio: .moreLeads,
                comment: "Serious dancers only. Bring your A-game."
            ),
            VenueReview(
                reviewerName: "Sam",
                venue: vidaLoca,
                energy: .competition,
                danceStyles: [.salsaOn1],
                difficulties: [.advanced],
                leadFollowRatio: .balanced,
                comment: "Tickets sell out — buy early."
            )
        ]
        vidaLocaReviews.forEach { context.insert($0) }

        // MARK: - Save

        try? context.save()
    }
}
