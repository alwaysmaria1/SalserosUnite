//
//  Event.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//

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

    init(
        name: String,
        venue: Venue? = nil,
        nextDate: Date = .now,
        cadenceLabel: String = "",
        friendsGoing: [String] = [],
        goingCount: Int = 0,
        isRSVPed: Bool = false
    ) {
        self.name = name
        self.venue = venue
        self.nextDate = nextDate
        self.cadenceLabel = cadenceLabel
        self.friendsGoing = friendsGoing
        self.goingCount = goingCount
        self.isRSVPed = isRSVPed
    }
}
