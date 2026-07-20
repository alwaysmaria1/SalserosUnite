//
//  Event.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// SwiftData model for a dance event and its fitting summaries.

import Foundation
import SwiftData

@Model
final class Event {
    var name: String
    var venue: Venue?
    var nextDate: Date
    var cadenceLabel: String       // display only, e.g. "biweekly" — no recurrence engine
    var friendsGoing: [String]     // seeded names
    var goingCount: Int            // seeded number
    var isRSVPed: Bool             // your real local RSVP state
    var isFavorite: Bool
    var eventMeasurements: EventMeasurements

    @Relationship(inverse: \Fitting.event)
    var fittings: [Fitting] = []

    init(
        name: String,
        venue: Venue? = nil,
        nextDate: Date = .now,
        cadenceLabel: String = "",
        friendsGoing: [String] = [],
        goingCount: Int = 0,
        isRSVPed: Bool = false,
        isFavorite: Bool = false,
        eventMeasurements: EventMeasurements = EventMeasurements(),
        fittings: [Fitting] = []
    ) {
        self.name = name
        self.venue = venue
        self.nextDate = nextDate
        self.cadenceLabel = cadenceLabel
        self.friendsGoing = friendsGoing
        self.goingCount = goingCount
        self.isRSVPed = isRSVPed
        self.isFavorite = isFavorite
        self.eventMeasurements = eventMeasurements
        self.fittings = fittings
    }

    // MARK: Crowdsourced information for Events Card from reviews

    //Goal here is to showcase a couple of the vibes as tags next to event cards
    //(like an event is outdoors and relaxed)
    //Answers the Q: "Which vibes have been reported most often for this event?"
    var topVibes: [Vibe] {
        //pulls out all the tags for all fittings into 1 list
        let allTags = allFittings.flatMap(\.vibeTags)
        //groups identical vibes together
        let counts: [Vibe: Int] = Dictionary(grouping: allTags, by: { $0 })
            .mapValues { $0.count }
        // Sorts by count first, then alphabetically so equal-count tags do not jump around.
        let sorted = counts.sorted {
            if $0.value == $1.value {
                return $0.key.rawValue < $1.key.rawValue
            }

            return $0.value > $1.value
        }
        return sorted.map { $0.key }.filter(\.isVisibleTag)
    }

    var allDanceStyles: Set<DanceStyle> {
        allFittings.reduce(into: Set<DanceStyle>()) { $0.formUnion($1.danceStylesTonight) }
    }

    var allDifficulties: Set<Difficulty> {
        allFittings.reduce(into: Set<Difficulty>()) { $0.formUnion($1.difficulties) }
    }

    var averageLeadFollowRatio: LeadFollowRatio? {
        mostCommon(allFittings.map(\.leadFollowRatio))
    }

    var allFittings: [Fitting] {
        fittings
    }

    var currentUserFitting: Fitting? {
        fitting(loggedByName: UserProfile.currentUserDisplayName)
    }

    func fitting(loggedByName: String) -> Fitting? {
        fittings.first { $0.loggedByName == loggedByName }
    }

    private func mostCommon<T: Hashable>(_ values: [T]) -> T? {
        guard !values.isEmpty else { return nil }
        let counts = Dictionary(grouping: values, by: { $0 }).mapValues(\.count)
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
