//
//  Fitting.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// SwiftData model for a user's review-like fitting of an event.

import Foundation
import SwiftData


//This is essentially a review for an event by a user

@Model
final class Fitting {
    var date: Date
    var event: Event
    var verdict: Verdict
    var vibeTags: Set<Vibe>
    var danceStylesTonight: Set<DanceStyle>
    var difficulties: Set<Difficulty>
    var leadFollowRatio: LeadFollowRatio
    var note: String
    var loggedByName: String
 
    init(
        date: Date = .now,
        event: Event,
        verdict: Verdict = .rack,
        vibeTags: Set<Vibe> = [],
        danceStylesTonight: Set<DanceStyle> = [],
        difficulties: Set<Difficulty> = [],
        leadFollowRatio: LeadFollowRatio = .balanced,
        note: String = "",
        loggedByName: String = "You"
    ) {
        self.date = date
        self.event = event
        self.verdict = verdict
        self.vibeTags = vibeTags
        self.danceStylesTonight = danceStylesTonight
        self.difficulties = difficulties
        self.leadFollowRatio = leadFollowRatio
        self.note = note
        self.loggedByName = loggedByName
    }
}
