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

    @State private var bookmarkedFittingIDs: Set<PersistentIdentifier> = []

    private var friendFittings: [Fitting] {
        fittings.filter { $0.loggedByName != UserProfile.currentUserDisplayName }
    }

    var body: some View {
        NavigationStack {
            List {
                friendFeedSection
            }
            .navigationTitle("Home")
            .listStyle(.insetGrouped)
        }
    }

    @ViewBuilder
    private var friendFeedSection: some View {
        if friendFittings.isEmpty {
            Section("Friends' Recent Fittings") {
                ContentUnavailableView(
                    "No Friend Fittings Yet",
                    systemImage: "person.2",
                    description: Text("Recent fittings from your friends will show up here.")
                )
            }
        } else {
            Section("Friends' Recent Fittings") {
                ForEach(friendFittings) { fitting in
                    FriendFittingCard(
                        fitting: fitting,
                        isBookmarked: isBookmarked(fitting),
                        onToggleBookmark: { toggleBookmark(for: fitting) }
                    )
                }
            }
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
