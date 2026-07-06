//
//  UserProfile.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
//
//  UserProfile.swift
//  SalsaLog
//
//  Only one UserProfile exists today — this is your local profile.
//  Because it's already its own entity rather than baked into settings,
//  real multi-profile switching later just means: allow multiple
//  UserProfile rows + track which one is "active" — not a redesign.
//
//  friendNames is a plain list of strings for now — no separate Friend
//  table, since a name is all a seeded friend needs. This can become a
//  list of real linked User references later without changing anything
//  that reads it today.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String
    var preferredStyles: Set<DanceStyle>
    var joinDate: Date
    var friendNames: [String]

    init(
        name: String = "",
        preferredStyles: Set<DanceStyle> = [],
        joinDate: Date = .now,
        friendNames: [String] = []
    ) {
        self.name = name
        self.preferredStyles = preferredStyles
        self.joinDate = joinDate
        self.friendNames = friendNames
    }
}
