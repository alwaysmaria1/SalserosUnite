//
//  CompactEventCard.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Compact event row for search results.

import SwiftUI

struct CompactEventCard: View {
    let event: Event
    let userFitting: Fitting?
    let isBookmarked: Bool
    let onToggleBookmark: () -> Void
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    private var subtitle: String {
        event.venue?.name ?? ""
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(event.name)
                    .font(.cardTitle)
                    .foregroundStyle(Color.ink)
                    .lineLimit(2)

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.cardMeta)
                        .foregroundStyle(Color.ink.opacity(0.62))
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 8)

            HStack(spacing: 12) {
                BookmarkButton(
                    isBookmarked: isBookmarked,
                    accessibilityName: "event",
                    onToggle: onToggleBookmark
                )
                FittingActionButton(
                    userFitting: userFitting,
                    onAddFitting: onAddFitting,
                    onEditFitting: onEditFitting
                )
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .listRowBackground(Color.cardCream)
    }
}
