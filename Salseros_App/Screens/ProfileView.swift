//
//  ProfileView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// User profile screen: hero banner, role badge, tally stats, and the swatch book of venues logged.

import SwiftUI
import SwiftData

struct ProfileView: View {
    private static let contentMaxWidth: CGFloat = 430

    @Query private var profiles: [UserProfile]
    @Query(sort: \Fitting.date, order: .reverse) private var fittings: [Fitting]

    @State private var selectedEventForDetails: Event?

    private var currentUser: UserProfile? {
        profiles.currentUser
    }

    private var userFittings: [Fitting] {
        fittings.filter { $0.loggedByName == UserProfile.currentUserDisplayName }
    }

    //One entry per venue Nico has logged, using the highest verdict earned there.
    //Sorted highest → lowest so the peak swatches sit at the top of the book.
    private var swatchEntries: [SwatchEntry] {
        let grouped = Dictionary(grouping: userFittings) { $0.event.venue?.persistentModelID }

        return grouped.compactMap { _, group -> SwatchEntry? in
            guard let peak = group.max(by: { $0.verdict.rank < $1.verdict.rank }),
                  let venue = peak.event.venue else {
                return nil
            }
            return SwatchEntry(venue: venue, event: peak.event, verdict: peak.verdict)
        }
        .sorted { lhs, rhs in
            if lhs.verdict.rank != rhs.verdict.rank {
                return lhs.verdict.rank > rhs.verdict.rank
            }
            return lhs.venue.name < rhs.venue.name
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProfileHeaderBanner(
                    name: currentUser?.name ?? "You",
                    tagline: currentUser?.profileTagline ?? ""
                )

                profileBody
                    .padding(.top, 24)
                    .padding(.bottom, 24)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: Self.contentMaxWidth, maxHeight: .infinity, alignment: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            .espressoBackground()
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedEventForDetails) { event in
                EventDetailsScreen(
                    event: event,
                    userFitting: event.currentUserFitting,
                    onAddFitting: {},
                    onEditFitting: { _ in }
                )
            }
        }
        .espressoBackground()
    }

    @ViewBuilder
    private var profileBody: some View {
        if let currentUser {
            VStack(spacing: 24) {
                HStack(spacing: 0) {
                    Spacer()
                    ProfileRoleBadge(role: currentUser.role)
                    Spacer()
                    ProfileStatColumn(value: userFittings.count, label: "Nights")
                    Spacer()
                }
                .padding(.horizontal, 32)

                divider

                swatchBookSection
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.ivory.opacity(0.18))
            .frame(height: 1)
            .padding(.horizontal, 32)
    }

    @ViewBuilder
    private var swatchBookSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("THE SWATCH BOOK")
                    .font(.eyebrow)
                    .tracking(3)
                    .foregroundStyle(Color.ivory.opacity(0.72))

                Spacer()

                Text("\(userFittings.count) \(userFittings.count == 1 ? "fitting" : "fittings")")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory.opacity(0.55))
            }
            .padding(.horizontal, 32)

            if swatchEntries.isEmpty {
                Text("Log a night to earn your first swatch.")
                    .font(.italicNote)
                    .foregroundStyle(Color.ivory.opacity(0.7))
                    .padding(.horizontal, 32)
            } else {
                VStack(spacing: 12) {
                    ForEach(swatchEntries) { entry in
                        SwatchRow(
                            venueName: entry.venue.name,
                            verdict: entry.verdict,
                            action: { selectedEventForDetails = entry.event }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

private struct SwatchEntry: Identifiable {
    let venue: Venue
    let event: Event
    let verdict: Verdict

    var id: PersistentIdentifier { venue.persistentModelID }
}
