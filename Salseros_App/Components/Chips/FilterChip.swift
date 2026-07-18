//
//  FilterChip.swift
//  Salseros_App
//
// Shared capsule label for active and inactive filters.

import SwiftUI

struct FilterChip: View {
    let title: String
    let isActive: Bool

    var body: some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isActive ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isActive ? Color.accentColor : Color.secondary.opacity(0.12), in: Capsule())
    }
}
