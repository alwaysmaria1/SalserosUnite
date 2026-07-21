//
//  UserProfile.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// SwiftData model for the local user's profile.

import Foundation
import SwiftData

@Model
final class UserProfile {
    static let currentUserDisplayName = "You"

    var name: String
    var role: DanceRole
    var preferredStyles: Set<DanceStyle>
    var joinDate: Date
    var friendNames: [String]

    @Relationship var bookmarkedEvents: [Event] = []

    init(
        name: String = "",
        role: DanceRole = .lead,
        preferredStyles: Set<DanceStyle> = [],
        joinDate: Date = .now,
        friendNames: [String] = [],
        bookmarkedEvents: [Event] = []
    ) {
        self.name = name
        self.role = role
        self.preferredStyles = preferredStyles
        self.joinDate = joinDate
        self.friendNames = friendNames
        self.bookmarkedEvents = bookmarkedEvents
    }

    //Banner tagline like "DANCING ON2 SINCE 2024" – derived from preferred style and join year.
    var profileTagline: String {
        let year = Calendar.current.component(.year, from: joinDate)
        let styleLabel: String
        if preferredStyles.contains(.mamboOn2) {
            styleLabel = "ON2"
        } else if preferredStyles.contains(.salsaOn1) {
            styleLabel = "ON1"
        } else if let first = preferredStyles.sorted(by: { $0.rawValue < $1.rawValue }).first {
            styleLabel = first.rawValue.uppercased()
        } else {
            styleLabel = "SALSA"
        }
        return "DANCING \(styleLabel) SINCE \(year)"
    }

    @MainActor
    static func current(in context: ModelContext) -> UserProfile {
        let profiles = (try? context.fetch(FetchDescriptor<UserProfile>())) ?? []

        if let profile = profiles.currentUser {
            return profile
        }

        let profile = UserProfile(name: "Noe")
        context.insert(profile)
        return profile
    }

    func isBookmarked(_ event: Event) -> Bool {
        bookmarkedEvents.contains { $0.persistentModelID == event.persistentModelID }
    }


    func setBookmark(_ isBookmarked: Bool, for event: Event) {
        if isBookmarked {
            guard !self.isBookmarked(event) else { return }
            bookmarkedEvents.append(event)
        } else {
            bookmarkedEvents.removeAll { $0.persistentModelID == event.persistentModelID }
        }
    }

}

extension Collection where Element == UserProfile {
    var currentUser: UserProfile? {
        first
    }
}
