//
//  HomeView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Home feed showing friends' recent fittings/visits to events.

import SwiftUI
import SwiftData
 
struct HomeView: View {
    @Query(sort: \Fitting.date, order: .reverse) private var fittings: [Fitting]
    @Query(sort: \Event.nextDate) private var events: [Event]
    let onLogNight: () -> Void
    let onPlan: () -> Void

    @State private var bookmarkedFittingIDs: Set<PersistentIdentifier> = []
    @State private var selectedEventForDetails: Event?
    @State private var selectedSheet: HomeSheet?

    private var friendFittings: [Fitting] {
        fittings.filter { $0.loggedByName != UserProfile.currentUserDisplayName }
    }

    private var featuredEvent: Event? {
        events.first { !$0.friendsGoing.isEmpty } ?? events.first
    }

    private var currentDateLabel: String {
        let day = Calendar.current.component(.day, from: .now)
        let suffix: String

        switch day {
        case 11, 12, 13:
            suffix = "th"
        default:
            switch day % 10 {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default:
                suffix = "th"
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMMM"
        return "\(formatter.string(from: .now)) \(day)\(suffix)"
    }

    private func promoDateText(for event: Event) -> String {
        event.nextDate.formatted(.dateTime.weekday(.abbreviated).month(.abbreviated).day())
    }

    init(
        onLogNight: @escaping () -> Void = {},
        onPlan: @escaping () -> Void = {}
    ) {
        self.onLogNight = onLogNight
        self.onPlan = onPlan
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 42) {
                    homeHeader

                    friendFeedContent
                }
                .padding(.top, 12)
            }
            .espressoBackground()
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedEventForDetails) { event in
                EventDetailsScreen(
                    event: event,
                    userFitting: event.currentUserFitting,
                    onAddFitting: { selectedSheet = .newFitting(event) },
                    onEditFitting: { selectedSheet = .editFitting($0) }
                )
            }
            .sheet(item: $selectedSheet) { sheet in
                fittingFlow(for: sheet)
            }
        }
        .espressoBackground()
    }

    @ViewBuilder
    private var homeHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Clavé")
                .font(.title.weight(.bold))
                .foregroundStyle(Color.ivory)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

            if let featuredEvent {
                Text(currentDateLabel)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ivory.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                friendsGoingCard(featuredEvent)
                    .padding(.horizontal, 24)

                HStack(spacing: 18) {
                    homeActionTile(title: "LOG A NIGHT", systemImage: "plus") {
                        onLogNight()
                    }

                    homeActionTile(title: "PLAN", systemImage: "calendar") {
                        onPlan()
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    private func friendsGoingCard(_ event: Event) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("NEXT UPCOMING SOCIAL")
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color.ink.opacity(0.72))
                .lineLimit(1)

            friendsGoingInfo(event)

            HStack(alignment: .bottom) {
                Text(promoDateText(for: event).uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.56))
                    .lineLimit(1)

                Spacer(minLength: 10)

                RSVPButton(isRSVPed: event.isRSVPed) {
                    event.isRSVPed.toggle()
                }
                .fixedSize(horizontal: true, vertical: false)
                .scaleEffect(0.78, anchor: .bottomTrailing)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private func friendsGoingInfo(_ event: Event) -> some View {
        HStack(spacing: 8) {
            AvatarStack(names: event.friendsGoing, size: 32)

            Button {
                selectedEventForDetails = event
            } label: {
                VStack(alignment: .leading, spacing: 3) {
                    Text(event.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(Color.ink)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)

                    Text(featuredEventSubtitle(for: event))
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.ink.opacity(0.62))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func homeActionTile(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.title3)

                Text(title)
                    .font(.caption.weight(.bold))
                    .tracking(2)
            }
            .foregroundStyle(Color.ink)
            .frame(maxWidth: .infinity)
            .frame(height: 96)
            .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func featuredEventSubtitle(for event: Event) -> String {
        [
            event.venue?.name,
            event.eventMeasurements.hours
        ].compactMap { value in
            guard let value, !value.isEmpty else { return nil }
            return value
        }
        .joined(separator: " · ")
    }

    @ViewBuilder
    private var friendFeedContent: some View {
        if friendFittings.isEmpty {
            ContentUnavailableView(
                "No Friend Fittings Yet",
                systemImage: "person.2",
                description: Text("Recent fittings from your friends will show up here.")
            )
            .padding()
            .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 24)
        } else {
            VStack(spacing: 0) {
                ForEach(Array(friendFittings.enumerated()), id: \.element.persistentModelID) { index, fitting in
                    FriendFittingCard(
                        fitting: fitting,
                        isBookmarked: isBookmarked(fitting),
                        onToggleBookmark: { toggleBookmark(for: fitting) },
                        onSelectEvent: { selectedEventForDetails = fitting.event }
                    )

                    if index < friendFittings.count - 1 {
                        Rectangle()
                            .fill(Color.ink.opacity(0.14))
                            .frame(height: 1)
                    }
                }
            }
            .overlay(alignment: .top) {
                MeasuringTapeDivider()
                    .offset(y: -16)
            }
        }
    }

    @ViewBuilder
    private func fittingFlow(for sheet: HomeSheet) -> some View {
        switch sheet {
        case .newFitting(let event):
            FittingFlowView(event: event)
        case .editFitting(let fitting):
            FittingFlowView(fitting: fitting)
        }
    }

    private func isBookmarked(_ fitting: Fitting) -> Bool {
        bookmarkedFittingIDs.contains(fitting.persistentModelID)
    }

    private func toggleBookmark(for fitting: Fitting) {
        let fittingID = fitting.persistentModelID

        if bookmarkedFittingIDs.contains(fittingID) {
            bookmarkedFittingIDs.remove(fittingID)
        } else {
            bookmarkedFittingIDs.insert(fittingID)
        }
    }
}

private enum HomeSheet: Identifiable {
    case newFitting(Event)
    case editFitting(Fitting)

    var id: HomeSheetID {
        switch self {
        case .newFitting(let event):
            .newFitting(ObjectIdentifier(event))
        case .editFitting(let fitting):
            .editFitting(ObjectIdentifier(fitting))
        }
    }
}

private enum HomeSheetID: Hashable {
    case newFitting(ObjectIdentifier)
    case editFitting(ObjectIdentifier)
}
