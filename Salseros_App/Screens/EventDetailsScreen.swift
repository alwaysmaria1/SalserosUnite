//
//  EventDetailsScreen.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Detail screen for venue, event info, and fitting reviews.

import SwiftUI

struct EventDetailsScreen: View {
    let event: Event
    let userFitting: Fitting?
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    private var sortedFittings: [Fitting] {
        event.fittings.sorted { $0.date > $1.date }
    }

    private var dateText: String {
        event.nextDate.formatted(date: .abbreviated, time: .shortened)
    }

    var body: some View {
        List {
            eventSection
            venueSection
            measurementsSection
            fittingSummarySection
            reviewsSection
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FittingActionButton(
                    userFitting: userFitting,
                    onAddFitting: onAddFitting,
                    onEditFitting: onEditFitting
                )
            }
        }
    }

    private var eventSection: some View {
        Section("Event") {
            LabeledContent("Next date", value: dateText)
            LabeledContent("Cadence", value: event.cadenceLabel.isEmpty ? "Not listed" : event.cadenceLabel)
            LabeledContent("Going", value: "\(event.goingCount)")

            if userFitting != nil {
                LabeledContent("Your fitting", value: "Logged")
            } else {
                LabeledContent("Your fitting", value: "Not logged")
            }

            if !event.friendsGoing.isEmpty {
                LabeledContent("Friends", value: event.friendsGoing.joined(separator: ", "))
            }
        }
    }

    private var venueSection: some View {
        Section("Venue") {
            LabeledContent("Name", value: event.venue?.name ?? "Unknown venue")

            if let city = event.venue?.city, !city.isEmpty {
                LabeledContent("City", value: city)
            }

            if let address = event.venue?.address, !address.isEmpty {
                LabeledContent("Address", value: address)
            }
        }
    }

    private var measurementsSection: some View {
        Section("Info") {
            measurementRow("Hours", event.eventMeasurements.hours)
            measurementRow("Cover", event.eventMeasurements.coverCharge)
            measurementRow("Dress code", event.eventMeasurements.dressCode)
            LabeledContent("Class before", value: event.eventMeasurements.classBefore ? "Yes" : "No")
            LabeledContent("Tickets needed", value: event.eventMeasurements.ticketsNeeded ? "Yes" : "No")
            LabeledContent("Alcohol", value: event.eventMeasurements.servesAlcohol ? "Yes" : "No")
        }
    }

    private var fittingSummarySection: some View {
        Section("From Fittings") {
            if sortedFittings.isEmpty {
                ContentUnavailableView("No fittings yet", systemImage: "text.bubble")
            } else {
                tagRow("Top vibes", values: event.topVibes.map(\.rawValue))
                tagRow("Dance styles", values: event.allDanceStyles.sortedRawValues)
                tagRow("Difficulty", values: event.allDifficulties.sortedRawValues)

                if let averageLeadFollowRatio = event.averageLeadFollowRatio {
                    LabeledContent("Lead/follow", value: averageLeadFollowRatio.rawValue)
                }
            }
        }
    }

    private var reviewsSection: some View {
        Section("Reviews") {
            if sortedFittings.isEmpty {
                Text("Add the first fitting for this event.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(sortedFittings) { fitting in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(fitting.loggedByName)
                                .font(.headline)

                            Spacer()

                            Text(fitting.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Text(fitting.verdict.rawValue)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)

                        tagFlow(values: fitting.vibeTags.sortedRawValues)
                        tagFlow(values: fitting.danceStylesTonight.sortedRawValues)

                        if !fitting.note.isEmpty {
                            Text(fitting.note)
                                .font(.body)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
        }
    }

    @ViewBuilder
    private func measurementRow(_ title: String, _ value: String) -> some View {
        if !value.isEmpty {
            LabeledContent(title, value: value)
        }
    }

    @ViewBuilder
    private func tagRow(_ title: String, values: [String]) -> some View {
        if !values.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                tagFlow(values: values)
            }
        }
    }

    @ViewBuilder
    private func tagFlow(values: [String]) -> some View {
        if !values.isEmpty {
            FlowChipLayout {
                ForEach(values, id: \.self) { value in
                    TagChip(title: value)
                }
            }
        }
    }
}
