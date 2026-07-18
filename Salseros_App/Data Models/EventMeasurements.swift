//
//  EventMeasurements.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Stored event info like dress code, cover, and venue details.

import Foundation

// Admin-managed infocard for a specific event/social.

struct EventMeasurements: Codable {
    var dressCode: String = ""
    var coverCharge: String = ""
    var hours: String = ""
    var classBefore: Bool = false
    var ticketsNeeded: Bool = false
    var servesAlcohol: Bool = false
}
