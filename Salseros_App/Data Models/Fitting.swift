//
//  Fitting.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//

import Foundation
import SwiftData
 
@Model
final class Fitting {
    var date: Date
    var event: Event
    var verdict: Verdict
    var vibeSwatch: String?     // optional one-tap "was this casual or competitive"-style note
    var note: String
    var loggedBy: UserProfile?  // the real person who logged this fitting
 
    init(
        date: Date = .now,
        event: Event,
        verdict: Verdict = .rack,
        vibeSwatch: String? = nil,
        note: String = "",
        loggedBy: UserProfile? = nil
    ) {
        self.date = date
        self.event = event
        self.verdict = verdict
        self.vibeSwatch = vibeSwatch
        self.note = note
        self.loggedBy = loggedBy
    }
}
