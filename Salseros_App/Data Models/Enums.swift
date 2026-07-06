//
//  Enums.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
//  Shared enums used across Venue, VenueReview, and (later) Fitting.
//
//  Created by Noelia Herne on 7/1/26.
//

//Defining the shape of the data within the app
//The app: Beli for Salsa Socials, helping salsa communities flourish
//typically you have to rely on knowing ppl and word of mouth

import Foundation

enum DanceStyle: String, Codable, CaseIterable, Identifiable {
    case salsaOn1 = "Salsa (On1)"
    case mamboOn2 = "Mambo (On2)"
    case bachata = "Bachata"
    case cumbia = "Cumbia"

    var id: String { rawValue }
}

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var id: String { rawValue }
}

enum Energy: String, Codable, CaseIterable, Identifiable {
    case formal = "Formal"
    case clubbing = "Clubbing"
    case casual = "Casual"
    case competition = "Competition"

    var id: String { rawValue }
}

enum LeadFollowRatio: String, Codable, CaseIterable, Identifiable {
    case moreLeads = "More leads"
    case balanced = "Balanced"
    case moreFollows = "More follows"

    var id: String { rawValue }
}

enum Verdict: String, Codable, CaseIterable, Identifiable {
    case rack = "Rack"
    case altered = "Altered"
    case toMeasure = "To Measure"
    case bespoke = "Bespoke"

    var id: String { rawValue }
}
