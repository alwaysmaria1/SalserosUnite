//
//  Measurements.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
//
//  "The tailor's chart" — fixed, logistical facts about a Venue.
//  These don't vary by reviewer, unlike Vibe (see VenueReview.swift).
//

import Foundation

struct Measurements: Codable {
    var dressCode: String = ""       // also covers shoe recommendation
    var coverCharge: String = ""
    var hours: String = ""           // operating window, e.g. "9PM-2AM"
    var classBefore: Bool = false
    var ticketsNeeded: Bool = false
    var servesAlcohol: Bool = false  // dry vs. not
}
