//
//  PlanView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Upcoming-events screen with filters, event details navigation, and fitting sheets.

import SwiftUI
import SwiftData

struct PlanView: View {
    @Query(sort: \Event.nextDate) private var events: [Event]

    @State private var selectedEventForDetails: Event?
    @State private var selectedSheet: PlanSheet?
    @State private var selectedCity: String?
    @State private var selectedVibes: Set<Vibe> = []
    @State private var selectedDifficulty: Difficulty?
    @State private var selectedDisplayMode: PlanDisplayMode = .list

    private let calendar = Calendar.current

    private var filteredEvents: [Event] {
        events.filter { event in
            matchesCity(event) && matchesVibe(event) && matchesDifficulty(event)
        }
    }

    private var tonightEvents: [Event] {
        filteredEvents.filter { calendar.isDateInToday($0.nextDate) }
    }

    private var nextWeekEvents: [Event] {
        let startOfToday = calendar.startOfDay(for: .now)
        guard
            let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday),
            let endOfNextWeek = calendar.date(byAdding: .day, value: 8, to: startOfToday)
        else { return [] }

        return filteredEvents.filter { event in
            event.nextDate >= startOfTomorrow && event.nextDate < endOfNextWeek
        }
    }

    private var cityOptions: [String] {
        Set(events.compactMap { event in
            guard let city = event.venue?.city, !city.isEmpty else { return nil }
            return city
        })
        .sorted()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                filtersSection
                displayContent
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 24)
            }
            .espressoBackground()
            .navigationBarTitleDisplayMode(.inline)
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

    private var header: some View {
        HStack(alignment: .center) {
            Text("Upcoming")
                .font(.displaySerif)
                .foregroundStyle(Color.ivory)

            Spacer(minLength: 16)

            Picker("Display", selection: $selectedDisplayMode) {
                ForEach(PlanDisplayMode.allCases) { mode in
                    Text(mode.title.uppercased()).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 178)
            .tint(Color.ivory)
        }
    }

    @ViewBuilder
    private var displayContent: some View {
        switch selectedDisplayMode {
        case .list:
            listContent
        case .calendar:
            calendarContent
        }
    }

    @ViewBuilder
    private var listContent: some View {
        eventSection("TONIGHT", events: tonightEvents)
        eventSection("NEXT WEEK", events: nextWeekEvents)
        emptyStateIfNeeded
    }

    @ViewBuilder
    private var calendarContent: some View {
        PlanCalendarView(events: filteredEvents) { event in
            eventRow(event)
        }
    }

    @ViewBuilder
    private var emptyStateIfNeeded: some View {
        if tonightEvents.isEmpty && nextWeekEvents.isEmpty {
            ContentUnavailableView(
                "No Events Match",
                systemImage: "line.3.horizontal.decrease.circle",
                description: Text("Try clearing a filter or choosing a different vibe.")
            )
            .padding()
            .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
        }
    }

    private var filtersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Menu {
                    Button("Any city") { selectedCity = nil }

                    ForEach(cityOptions, id: \.self) { city in
                        Button(city) { selectedCity = city }
                    }
                } label: {
                    Label(selectedCity ?? "City", systemImage: "mappin.circle")
                        .font(.eyebrow)
                        .foregroundStyle(selectedCity == nil ? Color.ink : Color.ivory)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(selectedCity == nil ? Color.ivory : Color.teal, in: Capsule())
                }

                ForEach(Vibe.allCases) { vibe in
                    Button {
                        toggleVibe(vibe)
                    } label: {
                        FilterChip(title: vibe.rawValue, isActive: selectedVibes.contains(vibe))
                    }
                    .buttonStyle(.plain)
                }

                ForEach(Difficulty.allCases) { difficulty in
                    Button {
                        toggleDifficulty(difficulty)
                    } label: {
                        FilterChip(title: difficulty.shortTitle, isActive: selectedDifficulty == difficulty)
                    }
                    .buttonStyle(.plain)
                }

                if hasActiveFilters {
                    Button("Clear") {
                        clearFilters()
                    }
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.rust, in: Capsule())
                }
            }
            .padding(.vertical, 2)
        }
    }

    @ViewBuilder
    private func eventSection(_ title: String, events: [Event]) -> some View {
        if !events.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory.opacity(0.82))

                ForEach(events) { event in
                    eventRow(event)
                        .padding(16)
                        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private func eventRow(_ event: Event) -> some View {
        EventCard(
            event: event,
            userFitting: event.currentUserFitting,
            onAddFitting: { selectedSheet = .newFitting(event) },
            onEditFitting: { selectedSheet = .editFitting($0) }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selectedEventForDetails = event
        }
    }

    @ViewBuilder
    private func fittingFlow(for sheet: PlanSheet) -> some View {
        switch sheet {
        case .newFitting(let event):
            FittingFlowView(event: event)
        case .editFitting(let fitting):
            FittingFlowView(fitting: fitting)
        }
    }

    private var hasActiveFilters: Bool {
        selectedCity != nil || !selectedVibes.isEmpty || selectedDifficulty != nil
    }

    private func clearFilters() {
        selectedCity = nil
        selectedVibes.removeAll()
        selectedDifficulty = nil
    }

    private func toggleVibe(_ vibe: Vibe) {
        if selectedVibes.contains(vibe) {
            selectedVibes.remove(vibe)
        } else {
            selectedVibes.insert(vibe)
        }
    }

    private func toggleDifficulty(_ difficulty: Difficulty) {
        selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
    }

    private func matchesCity(_ event: Event) -> Bool {
        guard let selectedCity else { return true }
        return event.venue?.city == selectedCity
    }

    private func matchesVibe(_ event: Event) -> Bool {
        guard !selectedVibes.isEmpty else { return true }
        return !selectedVibes.isDisjoint(with: Set(event.topVibes))
    }

    private func matchesDifficulty(_ event: Event) -> Bool {
        guard let selectedDifficulty else { return true }
        let difficulties = event.allDifficulties

        if selectedDifficulty == .allWelcome {
            return difficulties.contains(.allWelcome) || Difficulty.coreLevels.isSubset(of: difficulties)
        }

        return difficulties.contains(selectedDifficulty) || difficulties.contains(.allWelcome)
    }
}

private enum PlanDisplayMode: String, CaseIterable, Identifiable {
    case list
    case calendar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .list:
            "List"
        case .calendar:
            "Cal"
        }
    }
}

private enum PlanSheet: Identifiable {
    case newFitting(Event)
    case editFitting(Fitting)

    var id: PlanSheetID {
        switch self {
        case .newFitting(let event):
            .newFitting(ObjectIdentifier(event))
        case .editFitting(let fitting):
            .editFitting(ObjectIdentifier(fitting))
        }
    }
}

private enum PlanSheetID: Hashable {
    case newFitting(ObjectIdentifier)
    case editFitting(ObjectIdentifier)
}
