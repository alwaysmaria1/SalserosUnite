//
//  PlanView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Upcoming-events screen with filters, event details navigation, and fitting sheets.

import SwiftUI
import SwiftData
import UIKit

struct PlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Event.nextDate) private var events: [Event]
    @Query private var profiles: [UserProfile]

    @State private var selectedEventForDetails: Event?
    @State private var selectedSheet: PlanSheet?
    @State private var selectedCity: String?
    @State private var selectedVibes: Set<Vibe> = []
    @State private var selectedDifficulties: Set<Difficulty> = []
    @State private var showsMyEventsOnly = false
    @State private var selectedDisplayMode: PlanDisplayMode = .list

    private let calendar = Calendar.current

    init() {
        configureSegmentedControlAppearance()
    }

    private var filteredEvents: [Event] {
        events.filter { event in
            matchesCity(event) && matchesVibe(event) && matchesDifficulty(event) && matchesMyEvents(event)
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

    private func configureSegmentedControlAppearance() {
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(Color.ivory)
        ]
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(Color.ink)
        ]

        UISegmentedControl.appearance().backgroundColor = UIColor(Color.cardCream)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.rust)
        UISegmentedControl.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }

    private var header: some View {
        HStack(alignment: .center) {
            Text("Upcoming Socials")
                .font(.title3.weight(.bold))
                .foregroundStyle(Color.ivory)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Spacer(minLength: 10)

            Picker("Display", selection: $selectedDisplayMode) {
                ForEach(PlanDisplayMode.allCases) { mode in
                    Text(mode.title.uppercased()).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
            .tint(Color.rust)
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
        tonightSection
        eventSection("NEXT WEEK", events: nextWeekEvents)
        emptyStateIfNeeded
    }

    @ViewBuilder
    private var tonightSection: some View {
        if tonightEvents.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("TONIGHT")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory.opacity(0.82))

                Text("No events tonight")
                    .font(.cardMeta)
                    .foregroundStyle(Color.ink.opacity(0.68))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
            }
        } else {
            eventSection("TONIGHT", events: tonightEvents)
        }
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
            VStack(alignment: .leading, spacing: 6) {
                Text("No events match")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.ink.opacity(0.86))

                Text("Try clearing a filter or choosing a different vibe.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.ink.opacity(0.62))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
        }
    }

    private var filtersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Menu {
                    Button("Any city") { selectedCity = nil }

                    ForEach(cityOptions, id: \.self) { city in
                        Button(city) { selectedCity = city }
                    }
                } label: {
                    Label(selectedCity ?? "City", systemImage: "mappin.circle")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(selectedCity == nil ? Color.ink : Color.ivory)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(selectedCity == nil ? Color.ivory : Color.teal, in: Capsule())
                }

                Button {
                    showsMyEventsOnly.toggle()
                } label: {
                    Text("My events")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.ivory)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(showsMyEventsOnly ? Color.teal : Color.ivory.opacity(0.12), in: Capsule())
                        .overlay {
                            Capsule()
                                .stroke(showsMyEventsOnly ? Color.teal : Color.ivory.opacity(0.28), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Menu {
                    Button("Any difficulty") { selectedDifficulties.removeAll() }

                    ForEach(Difficulty.allCases) { difficulty in
                        Button {
                            toggleDifficulty(difficulty)
                        } label: {
                            Text("\(selectedDifficulties.contains(difficulty) ? "Selected: " : "")\(difficulty.rawValue)")
                        }
                    }
                } label: {
                    Label(difficultyFilterTitle, systemImage: "slider.horizontal.3")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(selectedDifficulties.isEmpty ? Color.ink : Color.ivory)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(selectedDifficulties.isEmpty ? Color.ivory : Color.rust, in: Capsule())
                }

                if hasActiveFilters {
                    Button("Clear") {
                        clearFilters()
                    }
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ivory)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Color.rust, in: Capsule())
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Vibe.filterCases) { vibe in
                        Button {
                            toggleVibe(vibe)
                        } label: {
                            FilterChip(title: vibe.displayTitle, isActive: selectedVibes.contains(vibe))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
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
        selectedCity != nil || !selectedVibes.isEmpty || !selectedDifficulties.isEmpty || showsMyEventsOnly
    }

    private var difficultyFilterTitle: String {
        guard !selectedDifficulties.isEmpty else { return "Level" }

        let titles = selectedDifficulties
            .map(\.shortTitle)
            .sorted()

        if titles.count > 2 {
            return "\(titles.prefix(2).joined(separator: ", ")) +\(titles.count - 2)"
        }

        return titles.joined(separator: ", ")
    }

    private func clearFilters() {
        selectedCity = nil
        selectedVibes.removeAll()
        selectedDifficulties.removeAll()
        showsMyEventsOnly = false
    }

    private func toggleVibe(_ vibe: Vibe) {
        if selectedVibes.contains(vibe) {
            selectedVibes.remove(vibe)
        } else {
            selectedVibes.insert(vibe)
        }
    }

    private func toggleDifficulty(_ difficulty: Difficulty) {
        if selectedDifficulties.contains(difficulty) {
            selectedDifficulties.remove(difficulty)
        } else {
            selectedDifficulties.insert(difficulty)
        }
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
        guard !selectedDifficulties.isEmpty else { return true }
        let difficulties = event.allDifficulties

        return selectedDifficulties.contains { selectedDifficulty in
            if selectedDifficulty == .allWelcome {
                return difficulties.contains(.allWelcome) || Difficulty.coreLevels.isSubset(of: difficulties)
            }

            return difficulties.contains(selectedDifficulty) || difficulties.contains(.allWelcome)
        }
    }

    private var currentUser: UserProfile {
        profiles.currentUser ?? UserProfile.current(in: modelContext)
    }

    private func matchesMyEvents(_ event: Event) -> Bool {
        !showsMyEventsOnly || currentUser.isBookmarked(event) || event.isRSVPed
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
