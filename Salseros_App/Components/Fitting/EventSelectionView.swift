//
//  EventSelectionView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Searchable list for choosing an event to log against.

import SwiftUI


//Full Screen for an event that shows the details and any potential reviews/fittings
struct EventSelectionView: View {
    let events: [Event]
    @Binding var searchText: String
    let onSelectEvent: (Event) -> Void

    private var filteredEvents: [Event] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return events }

        return events.filter { event in
            event.name.localizedCaseInsensitiveContains(query) ||
            (event.venue?.name.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    var body: some View {
        List {
            Section {
                TextField("Search events or venues", text: $searchText)
                    .textInputAutocapitalization(.words)
            }

            if filteredEvents.isEmpty {
                ContentUnavailableView(
                    "No Events Found",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Try a different event or venue name.")
                )
            } else {
                Section("Events") {
                    ForEach(filteredEvents) { event in
                        Button {
                            onSelectEvent(event)
                        } label: {
                            HStack {
                                Text(event.logDisplayName)
                                    .font(.cardMeta)
                                    .foregroundStyle(Color.ink)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.eyebrow)
                                    .foregroundStyle(Color.teal)
                            }
                        }
                        .listRowBackground(Color.cardCream)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .espressoBackground()
    }
}

extension Event {
    var logDisplayName: String {
        "\(venue?.name ?? "Unknown") - \(name)"
    }
}
