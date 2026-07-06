//
//  Venue.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
//
//  Venue.swift
//  SalsaLog
//

import Foundation
import SwiftData

@Model
final class Venue {
    var name: String
    var city: String
    var address: String
    var photoData: Data?
    var isStandingOrder: Bool
    var measurements: Measurements

    // The profile that logged this venue. Only one UserProfile exists today,
    // so every Venue you create just points at that same one — this is the
    // seam future multi-profile support hooks into, not active switching yet.
    var owner: UserProfile?

    @Relationship(deleteRule: .cascade, inverse: \VenueReview.venue)
    var reviews: [VenueReview] = []

    init(
        name: String,
        city: String = "",
        address: String = "",
        photoData: Data? = nil,
        isStandingOrder: Bool = false,
        measurements: Measurements = Measurements(),
        owner: UserProfile? = nil
    ) {
        self.name = name
        self.city = city
        self.address = address
        self.photoData = photoData
        self.isStandingOrder = isStandingOrder
        self.measurements = measurements
        self.owner = owner
    }

    // MARK: Computed vibe — derived from all reviews, not stored

    /// Most common energy across all reviewers. Nil if no reviews yet.
    var averageEnergy: Energy? {
        mostCommon(reviews.map(\.energy))
    }

    /// Union of every style any reviewer noted — a venue can host several.
    var allDanceStyles: Set<DanceStyle> {
        reviews.reduce(into: Set<DanceStyle>()) { $0.formUnion($1.danceStyles) }
    }

    /// Union of every difficulty any reviewer noted.
    var allDifficulties: Set<Difficulty> {
        reviews.reduce(into: Set<Difficulty>()) { $0.formUnion($1.difficulties) }
    }

    /// Most common lead/follow read across all reviewers.
    var averageLeadFollowRatio: LeadFollowRatio? {
        mostCommon(reviews.map(\.leadFollowRatio))
    }

    private func mostCommon<T: Hashable>(_ values: [T]) -> T? {
        guard !values.isEmpty else { return nil }
        let counts = Dictionary(grouping: values, by: { $0 }).mapValues(\.count)
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
