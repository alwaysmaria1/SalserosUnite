//
//  Enums.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
//  Shared enums used across Event and Fitting.
//
// Shared enum types used by events and fittings.

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
    case allWelcome = "All Welcome"

    var id: String { rawValue }

    var shortTitle: String {
        switch self {
        case .beginner:
            "Beg"
        case .intermediate:
            "Int"
        case .advanced:
            "Adv"
        case .allWelcome:
            "All"
        }
    }

    static let coreLevels: Set<Difficulty> = [.beginner, .intermediate, .advanced]
}

enum Vibe: String, Codable, CaseIterable, Identifiable { //should be multiselect
    case formal = "Dressed up"
    case clubbing = "Clubbing"
    case outdoors = "Outdoors" //or perhaps "summery"
    case indoors = "Indoors"
    case casual = "Casual"
    case summer = "Summer"
    //case competition = "Competition" might be out of scope for now

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .formal:
            "Dress code"
        default:
            rawValue
        }
    }

    var isVisibleTag: Bool {
        switch self {
        case .casual, .summer:
            false
        default:
            true
        }
    }

    static var filterCases: [Vibe] {
        allCases.filter(\.isVisibleTag)
    }
}

extension Set where Element: RawRepresentable, Element.RawValue == String {
    var sortedRawValues: [String] {
        map(\.rawValue).sorted()
    }
}

enum LeadFollowRatio: String, Codable, CaseIterable, Identifiable {
    case moreLeads = "More leads"
    case balanced = "Balanced"
    case moreFollows = "More follows"

    var id: String { rawValue }
}

//The role the user identifies as when they dance
enum DanceRole: String, Codable, CaseIterable, Identifiable {
    case lead = "Lead"
    case follow = "Follow"

    var id: String { rawValue }

    var imageName: String {
        switch self {
        case .lead:
            "shoes_lead"
        case .follow:
            "shoes_follow"
        }
    }
}

//This is the ranking system
enum Verdict: String, Codable, CaseIterable, Identifiable {
    case rack = "Rack"
    case altered = "Altered"
    case toMeasure = "To Measure"
    case bespoke = "Bespoke"

    var id: String { rawValue }

    //Higher value = better verdict. Used to sort the swatch book so peak fittings surface first.
    var rank: Int {
        switch self {
        case .rack:
            0
        case .altered:
            1
        case .toMeasure:
            2
        case .bespoke:
            3
        }
    }
}
