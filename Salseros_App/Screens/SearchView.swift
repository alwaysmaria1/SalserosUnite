//
//  SearchView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Search tab showing all events with compact rows and fitting actions.
// When a user wants to create a review, they first go to this page

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Event.name) private var events: [Event]
    @Query private var profiles: [UserProfile]

    @State private var searchText = ""
    @State private var selectedEventForDetails: Event?
    @State private var selectedSheet: SearchSheet?

    private var filteredEvents: [Event] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return events }

        return events.filter { event in
            event.name.localizedCaseInsensitiveContains(query) ||
            (event.venue?.name.localizedCaseInsensitiveContains(query) ?? false) ||
            (event.venue?.city.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if filteredEvents.isEmpty {
                    ContentUnavailableView(
                        "No Events Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try a different event, venue, or city.")
                    )
                    .listRowBackground(Color.cardCream)
                } else {
                    Section("Events") {
                        ForEach(filteredEvents) { event in
                            eventRow(event)
                        }
                    }
                    .listRowBackground(Color.cardCream)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search events, venues, cities")
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .espressoBackground()
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

    private func eventRow(_ event: Event) -> some View {
        CompactEventCard(
            event: event,
            userFitting: event.currentUserFitting,
            isBookmarked: isBookmarked(event),
            onToggleBookmark: { toggleBookmark(for: event) },
            onAddFitting: { selectedSheet = .newFitting(event) },
            onEditFitting: { selectedSheet = .editFitting($0) }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selectedEventForDetails = event
        }
    }

    private var currentUser: UserProfile {
        profiles.currentUser ?? UserProfile.current(in: modelContext)
    }

    private func isBookmarked(_ event: Event) -> Bool {
        currentUser.isBookmarked(event)
    }

    private func toggleBookmark(for event: Event) {
        let isBookmarked = !currentUser.isBookmarked(event)
        event.isFavorite = isBookmarked
        currentUser.setBookmark(isBookmarked, for: event)
        try? modelContext.save()
    }

    @ViewBuilder
    private func fittingFlow(for sheet: SearchSheet) -> some View {
        switch sheet {
        case .newFitting(let event):
            FittingFlowView(event: event)
        case .editFitting(let fitting):
            FittingFlowView(fitting: fitting)
        }
    }
}

private enum SearchSheet: Identifiable {
    case newFitting(Event)
    case editFitting(Fitting)

    var id: SearchSheetID {
        switch self {
        case .newFitting(let event):
            .newFitting(ObjectIdentifier(event))
        case .editFitting(let fitting):
            .editFitting(ObjectIdentifier(fitting))
        }
    }
}

private enum SearchSheetID: Hashable {
    case newFitting(ObjectIdentifier)
    case editFitting(ObjectIdentifier)
}
