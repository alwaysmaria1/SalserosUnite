//
//  FriendFittingCard.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Card showing a friend's recent fitting in the home feed.

import SwiftUI

struct FriendFittingCard: View {
    let fitting: Fitting
    let isBookmarked: Bool
    let onToggleBookmark: () -> Void

    private var subtitleParts: [String] {
        [
            fitting.event.name,
            fitting.event.venue?.name,
            fitting.date.formatted(date: .abbreviated, time: .omitted)
        ].compactMap { value in
            guard let value, !value.isEmpty else { return nil }
            return value
        }
    }

    private var initials: String {
        fitting.loggedByName
            .split(separator: " ")
            .compactMap { $0.first }
            .prefix(2)
            .map(String.init)
            .joined()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            imagePlaceholder

            HStack(alignment: .top, spacing: 12) {
                avatar

                VStack(alignment: .leading, spacing: 4) {
                    Text(fitting.loggedByName)
                        .font(.headline)

                    Text(subtitleParts.joined(separator: " · "))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                VStack(alignment: .trailing, spacing: 8) {
                    BookmarkButton(
                        isBookmarked: isBookmarked,
                        accessibilityName: "fitting",
                        onToggle: onToggleBookmark
                    )

                    Text(fitting.verdict.rawValue.lowercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            if !fitting.note.isEmpty {
                Text("\"\(fitting.note)\"")
                    .font(.body)
            }

            tagFlow
        }
        .padding(.vertical, 8)
    }

    private var avatar: some View {
        Text(initials.isEmpty ? "?" : initials)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(Color.accentColor, in: Circle())
    }

    private var imagePlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.12))

            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.title2)

                Text("Photo from the night")
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(.secondary)
        }
        .frame(height: 150)
    }

    @ViewBuilder
    private var tagFlow: some View {
        let tags = (fitting.vibeTags.sortedRawValues + fitting.danceStylesTonight.sortedRawValues)

        if !tags.isEmpty {
            FlowChipLayout {
                ForEach(tags, id: \.self) { tag in
                    TagChip(title: tag)
                }
            }
        }
    }
}
