//
//  BookmarkButton.swift
//  Salseros_App
//
// Shared bookmark toggle button for cards.

import SwiftUI

struct BookmarkButton: View {
    let isBookmarked: Bool
    let accessibilityName: String
    let onToggle: () -> Void

    var body: some View {
        Button {
            onToggle()
        } label: {
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.title3)
        }
        .buttonStyle(.plain)
        .foregroundStyle(isBookmarked ? Color.rust : Color.rust)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        isBookmarked ? "Remove \(accessibilityName) bookmark" : "Bookmark \(accessibilityName)"
    }
}
