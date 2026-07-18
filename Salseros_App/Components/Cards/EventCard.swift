//
//  EventCard.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Reusable card showing an event summary and fitting action.

import SwiftUI

struct EventCard: View {
    let event: Event
    let userFitting: Fitting?
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    private var subtitleParts: [String] {
        [
            event.venue?.name ?? "",
            event.eventMeasurements.hours,
            event.eventMeasurements.coverCharge
        ].filter { !$0.isEmpty }
    }

    private var additionalGoingCount: Int {
        max(0, event.goingCount - event.friendsGoing.count)
    }

    private var swatches: [EventSwatch] {
        let difficultySwatches = displayedDifficulties
            .sorted { $0.rawValue < $1.rawValue }
            .map { EventSwatch(title: $0.shortTitle, style: .level) }

        let vibeSwatches = event.topVibes
            .prefix(3)
            .map { EventSwatch(title: $0.rawValue, style: .vibe) }

        return Array((difficultySwatches + vibeSwatches).prefix(4))
    }

    private var displayedDifficulties: Set<Difficulty> {
        let difficulties = event.allDifficulties

        if difficulties.contains(.allWelcome) || Difficulty.coreLevels.isSubset(of: difficulties) {
            return [.allWelcome]
        }

        return difficulties
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(event.name)
                    .font(.cardTitle)
                    .foregroundStyle(Color.ink)

                Spacer(minLength: 12)

                if event.isFavorite {
                    Text("favorite")
                        .font(.eyebrow)
                        .foregroundStyle(Color.rust)
                }

                FittingActionButton(
                    userFitting: userFitting,
                    onAddFitting: onAddFitting,
                    onEditFitting: onEditFitting
                )
            }

            if !subtitleParts.isEmpty {
                Text(subtitleParts.joined(separator: " · "))
                    .font(.cardMeta)
                    .foregroundStyle(Color.ink.opacity(0.62))
            }

            if !swatches.isEmpty {
                FlowChipLayout {
                    ForEach(swatches) { swatch in
                        EventSwatchView(swatch: swatch)
                    }
                }
            }

            HStack(alignment: .center, spacing: 12) {
                goingSummary

                Spacer(minLength: 12)

                RSVPButton(
                    isRSVPed: event.isRSVPed,
                    onToggle: { event.isRSVPed.toggle() }
                )
            }
        }
        .padding(.vertical, 8)
        .listRowBackground(Color.cardCream)
    }

    @ViewBuilder
    private var goingSummary: some View {
        let visibleFriends = Array(event.friendsGoing.prefix(3))

        if visibleFriends.isEmpty && additionalGoingCount == 0 {
            Text("No one going yet")
                .font(.cardMeta)
                .foregroundStyle(Color.ink.opacity(0.62))
        } else {
            Text(summaryText(for: visibleFriends))
                .font(.cardMeta)
                .foregroundStyle(Color.ink.opacity(0.62))
        }
    }

    private func summaryText(for visibleFriends: [String]) -> String {
        var parts = visibleFriends

        if additionalGoingCount > 0 {
            parts.append("+ \(additionalGoingCount) going")
        }

        return parts.joined(separator: " · ")
    }
}

private struct EventSwatch: Identifiable {
    let title: String
    let style: EventSwatchStyle

    var id: String { "\(style.rawValue)-\(title)" }
}

private enum EventSwatchStyle: String {
    case level
    case vibe

    var foregroundColor: Color {
        switch self {
        case .level:
            Color.ivory
        case .vibe:
            Color.teal
        }
    }

    var backgroundColor: Color {
        switch self {
        case .level:
            Color.teal
        case .vibe:
            Color.rust.opacity(0.18)
        }
    }
}

private struct EventSwatchView: View {
    let swatch: EventSwatch

    var body: some View {
        Text(swatch.title)
            .font(.eyebrow)
            .foregroundStyle(swatch.style.foregroundColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(swatch.style.backgroundColor, in: Capsule())
    }
}
