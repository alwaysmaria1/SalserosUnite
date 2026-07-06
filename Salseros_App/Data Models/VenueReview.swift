//
//  VenueReview.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//

//
//  VenueReview.swift
//  SalsaLog
//
//  One person's take on a venue — yours or a seeded friend's.
//  One review per reviewer per venue; no re-ranking, no edits over time.
//

import Foundation
import SwiftData

@Model
final class VenueReview {
    var reviewerName: String        // "You" for your own, or a friend's name
    var venue: Venue?

    var energy: Energy
    var danceStyles: Set<DanceStyle>
    var difficulties: Set<Difficulty>
    var leadFollowRatio: LeadFollowRatio
    var comment: String

    init(
        reviewerName: String,
        venue: Venue? = nil,
        energy: Energy = .casual,
        danceStyles: Set<DanceStyle> = [],
        difficulties: Set<Difficulty> = [],
        leadFollowRatio: LeadFollowRatio = .balanced,
        comment: String = ""
    ) {
        self.reviewerName = reviewerName
        self.venue = venue
        self.energy = energy
        self.danceStyles = danceStyles
        self.difficulties = difficulties
        self.leadFollowRatio = leadFollowRatio
        self.comment = comment
    }
}
