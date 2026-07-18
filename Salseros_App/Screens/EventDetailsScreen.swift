//
//  EventDetailsScreen.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Detail screen for venue, event info, and fitting reviews.

import SwiftUI

struct EventDetailsScreen: View {
    @Environment(\.dismiss) private var dismiss

    let event: Event
    let userFitting: Fitting?
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    private var sortedFittings: [Fitting] {
        event.fittings.sorted { $0.date > $1.date }
    }

    private var dateEyebrow: String {
        let timeText = event.eventMeasurements.hours.isEmpty ? event.nextDate.formatted(date: .omitted, time: .shortened) : event.eventMeasurements.hours
        return "TONIGHT · \(timeText)"
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

        return pieces.isEmpty ? "\(event.goingCount) going" : pieces.joined(separator: ", ")
    }

    private var vibeSentence: String {
        let difficulty = event.allDifficulties.sortedRawValues.first ?? "Open"
        let vibe = event.topVibes.first?.rawValue ?? "social"
        let ratio = event.averageLeadFollowRatio?.rawValue ?? "balanced"
        return "\(difficulty) crowd. \(vibe) energy. \(ratio) lead:follow."
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    hero
                    eventHeader
                    goingCard
                    measurementsSection
                    vibeSection
                    wordOfMouthSection
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 128)
            }
            .ignoresSafeArea(edges: .top)
            .espressoBackground()
            .toolbar(.hidden, for: .navigationBar)

            bottomBar
        }
        .espressoBackground()
    }

    private var hero: some View {
        ZStack {
            Rectangle()
                .fill(Color.ink.opacity(0.26))
                .overlay {
                    DiagonalStripePattern()
                        .stroke(Color.ink.opacity(0.14), lineWidth: 8)
                }

            Text("VENUE PHOTO")
                .font(.eyebrow)
                .foregroundStyle(Color.ivory.opacity(0.58))

            HStack {
                circleIconButton("chevron.left", action: { dismiss() })
                Spacer()
                circleIconButton(event.isFavorite ? "bookmark.fill" : "bookmark") {
                    event.isFavorite.toggle()
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 68)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 220)
        .padding(.horizontal, -24)
    }

    private var eventHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(dateEyebrow)
                .font(.eyebrow)
                .foregroundStyle(Color.rust)

            Text(event.name)
                .font(.displaySerif)
                .foregroundStyle(Color.ivory)
                .lineLimit(2)
                .minimumScaleFactor(0.74)

            if event.isFavorite {
                Text("standing order")
                    .font(.italicNote)
                    .foregroundStyle(Color.rust)
            }

            if !venueLine.isEmpty {
                Text(venueLine)
                    .font(.cardMeta)
                    .foregroundStyle(Color.ivory.opacity(0.82))
            }
        }
    }

    private var goingCard: some View {
        HStack(spacing: 14) {
            avatarStack(for: event.friendsGoing)

            Text(goingText)
                .font(.cardMeta)
                .foregroundStyle(Color.ink.opacity(0.72))
                .lineLimit(1)

            Spacer(minLength: 8)

            RSVPButton(isRSVPed: event.isRSVPed) {
                event.isRSVPed.toggle()
            }
            .scaleEffect(0.9)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private var measurementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("MEASUREMENTS")
                .font(.eyebrow)
                .foregroundStyle(Color.ivory)

            VStack(spacing: 0) {
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

    private var vibeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("THE VIBE")
                .font(.eyebrow)
                .foregroundStyle(Color.ivory)

            Text(vibeSentence)
                .font(.title.weight(.bold))
                .foregroundStyle(Color.ivory)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var wordOfMouthSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("WORD OF MOUTH")
                .font(.eyebrow)
                .foregroundStyle(Color.ivory)

            if let fitting = sortedFittings.first {
                reviewCard(fitting)
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
        HStack(spacing: 18) {
            Button {
                // Directions are visual-only until map routing is added.
            } label: {
                Text("GET DIRECTIONS")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 19)
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
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.ivory)
                    .frame(width: 72, height: 72)
                    .background(Color.teal, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(userFitting == nil ? "Add fitting" : "Edit fitting")
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .background(Color.espresso.opacity(0.92))
    }

    private var receiptDivider: some View {
        ReceiptDashedLine(color: Color.ink.opacity(0.2))
            .padding(.horizontal, 18)
    }

    private func measurementRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.cardTitle)
                .foregroundStyle(Color.ink)

            Spacer(minLength: 12)

            Text(value.isEmpty ? "Not listed" : value)
                .font(.cardMeta)
                .foregroundStyle(title == "Cover" ? Color.rust : Color.ink.opacity(0.64))
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    private func reviewCard(_ fitting: Fitting) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(fitting.loggedByName)
                    .font(.cardTitle)
                    .foregroundStyle(Color.ink)

                Text("\(fittingCount(for: fitting.loggedByName)) NIGHTS")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ink.opacity(0.56))

                Spacer()

                Text(fitting.verdict.rawValue.lowercased())
                    .font(.italicNote)
                    .foregroundStyle(Color.ink)
            }

            if !fitting.note.isEmpty {
                Text(fitting.note)
                    .font(.italicNote)
                    .foregroundStyle(Color.ink.opacity(0.82))
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private func fittingCount(for name: String) -> Int {
        event.fittings.filter { $0.loggedByName == name }.count
    }

    private func avatarStack(for names: [String]) -> some View {
        HStack(spacing: -8) {
            ForEach(Array(names.prefix(3).enumerated()), id: \.offset) { index, name in
                Text(initials(for: name))
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory)
                    .frame(width: 34, height: 34)
                    .background(avatarColor(at: index), in: Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.cardCream, lineWidth: 2)
                    }
            }
        }
    }

    private func circleIconButton(_ systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.ivory)
                .frame(width: 56, height: 56)
                .background(Color.ink.opacity(0.38), in: Circle())
        }
        .buttonStyle(.plain)
    }

    private func initials(for name: String) -> String {
        let initials = name
            .split(separator: " ")
            .compactMap(\.first)
            .prefix(2)
            .map(String.init)
            .joined()

        return initials.isEmpty ? "?" : initials
    }

    private func avatarColor(at index: Int) -> Color {
        switch index {
        case 0:
            return Color.ink
        case 1:
            return Color.rust
        default:
            return Color.espresso.opacity(0.75)
        }
    }
}

private struct DiagonalStripePattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 18
        var x = -rect.height

        while x < rect.width {
            path.move(to: CGPoint(x: x, y: rect.maxY))
            path.addLine(to: CGPoint(x: x + rect.height, y: rect.minY))
            x += spacing
        }

        return path
    }
}
