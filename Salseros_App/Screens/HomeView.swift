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
                LazyVStack(alignment: .leading, spacing: 28) {
                    homeHeader

                    Text("WHERE FRIENDS HAVE BEEN DANCING")
                        .font(.eyebrow)
                        .foregroundStyle(Color.ivory)
                        .padding(.horizontal, 24)

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
        VStack(alignment: .leading, spacing: 22) {
            Text("Clave")
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.ivory)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

            if let featuredEvent {
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
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 14) {
                Text("FRIENDS ARE GOING")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ink.opacity(0.62))

                HStack(spacing: 10) {
                    avatarStack(for: event.friendsGoing)

                    Button {
                        selectedEventForDetails = event
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.name)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(Color.ink)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .multilineTextAlignment(.leading)

                            Text(featuredEventSubtitle(for: event))
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.ink.opacity(0.62))
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            RSVPButton(isRSVPed: event.isRSVPed) {
                event.isRSVPed.toggle()
            }
            .fixedSize(horizontal: true, vertical: false)
            .scaleEffect(0.86)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private func homeActionTile(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title2)

                Text(title)
                    .font(.eyebrow)
            }
            .foregroundStyle(Color.ink)
            .frame(maxWidth: .infinity)
            .frame(height: 124)
            .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }

    private func avatarStack(for names: [String]) -> some View {
        HStack(spacing: -8) {
            ForEach(Array(names.prefix(3).enumerated()), id: \.offset) { index, name in
                Text(initials(for: name))
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory)
                    .frame(width: 32, height: 32)
                    .background(avatarColor(at: index), in: Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.cardCream, lineWidth: 2)
                    }
            }
        }
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
            return Color.teal
        case 1:
            return Color.rust
        default:
            return Color.ink
        }
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
