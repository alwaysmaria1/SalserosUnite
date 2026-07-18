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
            .font(.eyebrow)
            .foregroundStyle(isActive ? Color.ivory : Color.mutedIvory)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isActive ? Color.teal : Color.ivory.opacity(0.12), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(isActive ? Color.teal : Color.ivory.opacity(0.22), lineWidth: 1)
            }
    }
}
