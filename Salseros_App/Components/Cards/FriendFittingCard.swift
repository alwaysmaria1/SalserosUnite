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
    let onSelectEvent: () -> Void

    private var relativeDateText: String {
        let calendar = Calendar.current

        if calendar.isDateInToday(fitting.date) {
            return "today"
        }

        if calendar.isDateInYesterday(fitting.date) {
            return "1 day ago"
        }

        let startOfToday = calendar.startOfDay(for: .now)
        let startOfDate = calendar.startOfDay(for: fitting.date)
        let dayCount = calendar.dateComponents([.day], from: startOfDate, to: startOfToday).day ?? 0

        if dayCount > 1 {
            return "\(dayCount) days ago"
        }

        return fitting.date.formatted(date: .abbreviated, time: .omitted)
    }

    private var initials: String {
        fitting.loggedByName
            .split(separator: " ")
            .compactMap { $0.first }
            .prefix(2)
            .map(String.init)
            .joined()
    }

    private var venueName: String {
        fitting.event.venue?.name ?? "the social"
    }

    private var verdictPhrase: String {
        switch fitting.verdict {
        case .rack:
            return "off the rack"
        case .altered:
            return "altered"
        case .toMeasure:
            return "to measure"
        case .bespoke:
            return "bespoke"
        }
    }

    private var postHeadline: String {
        "\(fitting.loggedByName) danced at \(venueName) and it was \(verdictPhrase)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                avatar

                VStack(alignment: .leading, spacing: 4) {
                    Text(postHeadline)
                        .font(.cardTitle)
                        .foregroundStyle(Color.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(relativeDateText)
                        .font(.cardMeta)
                        .foregroundStyle(Color.ink.opacity(0.62))
                }

                Spacer(minLength: 12)
                
                BookmarkButton(
                    isBookmarked: isBookmarked,
                    accessibilityName: "fitting",
                    onToggle: onToggleBookmark
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 22)
            .padding(.bottom, 16)

            imagePlaceholder

            VStack(alignment: .leading, spacing: 14) {
                Button(action: onSelectEvent) {
                    Text(fitting.event.name)
                        .font(.cardTitle)
                        .foregroundStyle(Color.ink)
                        .multilineTextAlignment(.leading)
                }
                .buttonStyle(.plain)

                tagFlow

                if !fitting.note.isEmpty {
                    Text(fitting.note)
                        .font(.italicNote)
                        .foregroundStyle(Color.ink)
                }

                Text(venueName)
                    .font(.cardMeta)
                    .foregroundStyle(Color.ink.opacity(0.62))
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardCream)
        .overlay(alignment: .top) {
            ReceiptDashedLine(color: Color.ink.opacity(0.22))
                .padding(.horizontal, 24)
        }
    }

    private var avatar: some View {
        Text(initials.isEmpty ? "?" : initials)
            .font(.subheadline.weight(.bold))
            .foregroundStyle(Color.ivory)
            .frame(width: 40, height: 40)
            .background(Color.teal, in: Circle())
    }

    private var imagePlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.teal.opacity(0.14))

            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.title2)

                Text("Photo from the night")
                    .font(.eyebrow)
            }
            .foregroundStyle(Color.teal)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 210)
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
