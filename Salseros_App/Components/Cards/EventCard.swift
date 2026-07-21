//
//  EventCard.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Reusable card showing an event summary and fitting action.

import SwiftUI
import SwiftData

struct EventCard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    let event: Event
    let userFitting: Fitting?
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    private var dateTimeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE M/d"
        let dateText = formatter.string(from: event.nextDate).replacingOccurrences(of: "Thu", with: "Thurs")
        return "\(dateText) @ \(startTimeText)"
    }

    private var startTimeText: String {
        let start = event.eventMeasurements.hours
            .components(separatedBy: "-")
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let start, !start.isEmpty else {
            return event.nextDate.formatted(.dateTime.hour(.defaultDigits(amPM: .abbreviated)).minute(.omitted))
        }

        return start
    }

    private var swatches: [EventDisplayTag] {
        let difficultySwatches = displayedDifficulties
            .sorted { $0.rawValue < $1.rawValue }
            .map { EventDisplayTag(title: $0.shortTitle, style: .difficulty) }

        let vibeSwatches = event.topVibes
            .prefix(2)
            .map { EventDisplayTag(title: $0.displayTitle, style: .standard) }

        let danceSwatches = event.allDanceStyles
            .sortedRawValues
            .prefix(2)
            .map { EventDisplayTag(title: $0, style: .standard) }

        return Array((difficultySwatches + vibeSwatches + danceSwatches).prefix(5))
    }

    private var displayedDifficulties: Set<Difficulty> {
        let difficulties = event.allDifficulties

        if difficulties.contains(.allWelcome) || Difficulty.coreLevels.isSubset(of: difficulties) {
            return [.allWelcome]
        }

        return difficulties
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(event.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.ink)
                    .lineLimit(2)

                Spacer(minLength: 12)

                if currentUser.isBookmarked(event) {
                    Text("favorite")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color.rust)
                }

                FittingActionButton(
                    userFitting: userFitting,
                    onAddFitting: onAddFitting,
                    onEditFitting: onEditFitting
                )
            }

            if !swatches.isEmpty {
                FlowChipLayout {
                    ForEach(swatches) { swatch in
                        EventTagChip(tag: swatch)
                    }
                }
            }

            HStack(alignment: .center, spacing: 12) {
                goingSummary

                Spacer(minLength: 12)

                RSVPButton(
                    isRSVPed: event.isRSVPed,
                    onToggle: toggleRSVP
                )
            }
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.cardCream)
        .overlay(alignment: .topLeading) {
            PinView()
                .offset(x: 10, y: -25)
        }
    }

    private var currentUser: UserProfile {
        profiles.currentUser ?? UserProfile.current(in: modelContext)
    }

    private func toggleRSVP() {
        event.isRSVPed.toggle()
        try? modelContext.save()
    }

    private var goingSummary: some View {
        Text(dateTimeText)
            .font(.eyebrow)
            .foregroundStyle(Color.rust)
            .lineLimit(1)
    }
}

private struct PinView: View {
    var body: some View {
        Circle()
            .fill(Color(red: 0.95, green: 0.42, blue: 0.08))
            .frame(width: 18, height: 18)
            .shadow(color: Color.ink.opacity(0.35), radius: 4, x: 0, y: 3)
    }
}

