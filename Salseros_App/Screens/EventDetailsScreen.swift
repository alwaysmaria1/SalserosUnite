//
//  EventDetailsScreen.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Detail screen for venue, event info, and fitting reviews.

import SwiftUI
import SwiftData

struct EventDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]

    let event: Event
    let userFitting: Fitting?
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    private var sortedFittings: [Fitting] {
        event.fittings.sorted { $0.date > $1.date }
    }

    private var timeText: String {
        event.eventMeasurements.hours.isEmpty ? event.nextDate.formatted(date: .omitted, time: .shortened) : event.eventMeasurements.hours
    }

    private var venueLine: String {
        [
            event.venue?.name,
            event.venue?.city
        ].compactMap { value in
            guard let value, !value.isEmpty else { return nil }
            return value
        }
        .joined(separator: " · ")
    }

    private var goingText: String {
        let visibleFriends = Array(event.friendsGoing.prefix(2))
        let remainder = max(0, event.goingCount - visibleFriends.count)
        var pieces = visibleFriends

        if remainder > 0 {
            pieces.append("+ \(remainder) going")
        }

        return pieces.isEmpty ? "+ \(event.goingCount) going" : pieces.joined(separator: ", ")
    }

    private var nextEventLabel: String {
        Calendar.current.isDateInToday(event.nextDate)
            ? "TONIGHT"
            : event.nextDate.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()).uppercased()
    }

    private var attendeeAvatarNames: [String] {
        if !event.friendsGoing.isEmpty {
            return event.friendsGoing
        }

        return (1...max(1, min(event.goingCount, 3))).map { "Guest \($0)" }
    }

    private var detailTags: [EventDisplayTag] {
        let difficultyTags = event.allDifficulties
            .sorted { $0.rawValue < $1.rawValue }
            .map { EventDisplayTag(title: $0.rawValue, style: .difficulty) }

        let vibeTags = event.topVibes
            .map { EventDisplayTag(title: $0.displayTitle, style: .standard) }

        let danceTags = event.allDanceStyles
            .sortedRawValues
            .map { EventDisplayTag(title: $0, style: .standard) }

        let ratioTags = event.averageLeadFollowRatio
            .map { [EventDisplayTag(title: $0.rawValue, style: .standard)] } ?? []

        return Array((difficultyTags + vibeTags + danceTags + ratioTags).prefix(8))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                topHeader

                VStack(alignment: .leading, spacing: 18) {
                    eventHeader
                    nextEventSection
                    measurementsSection
                    wordOfMouthSection
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 128)
            }
            .ignoresSafeArea(edges: .top)
            .espressoBackground()

            bottomBar
        }
        .espressoBackground()
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topHeader: some View {
        ZStack(alignment: .bottom) {
            Color.ink
                .opacity(0.72)
                .ignoresSafeArea(edges: .top)

            HStack {
                circleIconButton("chevron.left", action: { dismiss() })
                Spacer()
                circleIconButton(
                    currentUser.isBookmarked(event) ? "bookmark.fill" : "bookmark",
                    isSelected: currentUser.isBookmarked(event)
                ) {
                    toggleBookmark()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 56)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 110)
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [Color.teal, Color.rust, Color(red: 0.96, green: 0.78, blue: 0.22)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 4)
        }
    }

    private var eventHeader: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(event.name)
                .font(.title.weight(.bold))
                .foregroundStyle(Color.ivory)
                .lineLimit(2)
                .minimumScaleFactor(0.82)

            if !venueLine.isEmpty {
                Text(venueLine)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.ivory.opacity(0.82))
            }
        }
    }

    private var nextEventSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NEXT UPCOMING EVENT")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.ivory)

            goingCard
        }
    }

    private var goingCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(nextEventLabel)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.82))

                Spacer()

                Text(timeText)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.62))
                    .lineLimit(1)
            }

            HStack(spacing: 12) {
                AvatarStack(
                    names: attendeeAvatarNames,
                    size: 34,
                    palette: [Color.ink, Color.rust, Color.espresso.opacity(0.75)]
                )

                Text(goingText)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.ink)
                    .lineLimit(1)

                Spacer(minLength: 8)

                RSVPButton(isRSVPed: event.isRSVPed) {
                    toggleRSVP()
                }
                .scaleEffect(0.86)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private var measurementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("MEASUREMENTS")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.ivory)

            VStack(spacing: 0) {
                detailTagGrid
                    .padding(.horizontal, 18)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                receiptDivider
                measurementRow("Hours", event.eventMeasurements.hours)
                receiptDivider
                measurementRow("Cover", event.eventMeasurements.coverCharge)
                receiptDivider
                measurementRow("Dress code", event.eventMeasurements.dressCode)
                receiptDivider
                measurementRow("Serves alcohol", event.eventMeasurements.servesAlcohol ? "Yes" : "No")
            }
            .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
        }
    }

    @ViewBuilder
    private var detailTagGrid: some View {
        if detailTags.isEmpty {
            Text("No vibe tags yet")
                .font(.cardMeta)
                .foregroundStyle(Color.ink.opacity(0.62))
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            FlowChipLayout {
                ForEach(detailTags) { tag in
                    EventTagChip(
                        tag: tag,
                        font: .caption.weight(.bold),
                        horizontalPadding: 12,
                        verticalPadding: 7
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var wordOfMouthSection: some View {
        VStack(alignment: .leading, spacing: 16) {
                Text("WORD OF MOUTH")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.ivory)

            if let fitting = sortedFittings.first {
                FriendFittingCard(
                    fitting: fitting,
                    isEventBookmarked: currentUser.isBookmarked(fitting.event),
                    onToggleEventBookmark: { toggleBookmark() },
                    onSelectEvent: {}
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Text("Add the first fitting for this event.")
                    .font(.cardMeta)
                    .foregroundStyle(Color.ink.opacity(0.62))
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 12) {
            Button {
                // Directions are visual-only until map routing is added.
            } label: {
                Text("GET DIRECTIONS")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.cardCream, in: Capsule())
            }
            .buttonStyle(.plain)

            Button {
                if let userFitting {
                    onEditFitting(userFitting)
                } else {
                    onAddFitting()
                }
            } label: {
                Image(systemName: userFitting == nil ? "plus" : "pencil")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color.ivory)
                    .frame(width: 54, height: 54)
                    .background(Color.teal, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(userFitting == nil ? "Add fitting" : "Edit fitting")
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 16)
        .background(Color.espresso.opacity(0.92))
    }

    private var receiptDivider: some View {
        ReceiptDashedLine(color: Color.ink.opacity(0.2))
            .padding(.horizontal, 18)
    }

    private func measurementRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
                Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.ink)

            Spacer(minLength: 12)

            Text(value.isEmpty ? "Not listed" : value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.ink)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    private func reviewCard(_ fitting: Fitting) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(fitting.loggedByName)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.ink)

                Text("\(fittingCount(for: fitting.loggedByName)) NIGHTS")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.56))

                Spacer()

                Text(fitting.verdict.rawValue.lowercased())
                    .font(.italicNote)
                    .foregroundStyle(Color.ink)
            }

            if !fitting.note.isEmpty {
                Text(fitting.note)
                    .font(.callout)
                    .foregroundStyle(Color.ink.opacity(0.82))
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private var currentUser: UserProfile {
        profiles.currentUser ?? UserProfile.current(in: modelContext)
    }

    private func fittingCount(for name: String) -> Int {
        event.fittings.filter { $0.loggedByName == name }.count
    }

    private func toggleRSVP() {
        event.isRSVPed.toggle()
        try? modelContext.save()
    }

    private func toggleBookmark() {
        let isBookmarked = !currentUser.isBookmarked(event)
        event.isFavorite = isBookmarked
        currentUser.setBookmark(isBookmarked, for: event)
        try? modelContext.save()
    }


    private func circleIconButton(
        _ systemImage: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(isSelected ? Color.rust : Color.ivory)
                .frame(width: 56, height: 56)
                .background(Color.ink.opacity(0.38), in: Circle())
        }
        .buttonStyle(.plain)
    }

}
