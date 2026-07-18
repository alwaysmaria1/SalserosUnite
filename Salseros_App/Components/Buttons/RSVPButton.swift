//
//  RSVPButton.swift
//  Salseros_App
//
// Shared RSVP toggle button for event cards.

import SwiftUI

struct RSVPButton: View {
    let isRSVPed: Bool
    let onToggle: () -> Void

    var body: some View {
        if isRSVPed {
            Button {
                onToggle()
            } label: {
                Label("GOING", systemImage: "checkmark")
            }
            .buttonStyle(PillActionStyle())
            .accessibilityLabel("Cancel RSVP")
        } else {
            Button {
                onToggle()
            } label: {
                Text("RSVP")
            }
            .buttonStyle(OutlinePillStyle())
            .accessibilityLabel("RSVP")
        }
    }
}
