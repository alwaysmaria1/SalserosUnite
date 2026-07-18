//
//  Venue.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// SwiftData model for a physical event venue.

import Foundation
import SwiftData

//This is the specific location for an event, allows for future scope of multiple events can
//have the same venue, also used in mapping

@Model
final class Venue {
    var name: String
    var city: String
    var address: String

    init(
        name: String,
        city: String = "",
        address: String = ""
    ) {
        self.name = name
        self.city = city
        self.address = address
    }
}
