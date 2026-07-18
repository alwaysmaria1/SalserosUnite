//
//  LogView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Hidden log tab wrapper for choosing an event and opening fitting flow.

import SwiftUI
import SwiftData

struct LogView: View {
    @Query(sort: \Event.name) private var events: [Event]

    @State private var searchText = ""
    @State private var selectedEventForFitting: Event?

    var body: some View {
        NavigationStack {
            EventSelectionView(
                events: events,
                searchText: $searchText,
                onSelectEvent: { selectedEventForFitting = $0 }
            )
            .navigationTitle("Log")
            .sheet(item: $selectedEventForFitting) { event in
                FittingFlowView(event: event)
            }
        }
    }
}
