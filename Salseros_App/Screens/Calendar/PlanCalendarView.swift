//
//  PlanCalendarView.swift
//  Salseros_App
//
// Calendar page for browsing filtered upcoming events by month.

import SwiftUI

struct PlanCalendarView<EventRow: View>: View {
    let events: [Event]
    @ViewBuilder let eventRow: (Event) -> EventRow

    @State private var displayedMonth = Date.now
    @State private var selectedDate = Date.now

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    private var monthTitle: String {
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    private var weekdaySymbols: [String] {
        calendar.shortStandaloneWeekdaySymbols
    }

    private var monthDates: [Date?] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
            let monthDayRange = calendar.range(of: .day, in: .month, for: displayedMonth)
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: monthInterval.start)
        let leadingEmptyDays = firstWeekday - calendar.firstWeekday
        let normalizedLeadingEmptyDays = leadingEmptyDays >= 0 ? leadingEmptyDays : leadingEmptyDays + 7
        let dates = monthDayRange.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start)
        }

        return Array(repeating: nil, count: normalizedLeadingEmptyDays) + dates
    }

    private var selectedDayEvents: [Event] {
        events
            .filter { calendar.isDate($0.nextDate, inSameDayAs: selectedDate) }
            .sorted { $0.nextDate < $1.nextDate }
    }

    var body: some View {
        Section {
            CalendarMonthHeader(
                title: monthTitle,
                onPreviousMonth: { moveDisplayedMonth(by: -1) },
                onNextMonth: { moveDisplayedMonth(by: 1) }
            )

            CalendarWeekdayHeader(weekdaySymbols: weekdaySymbols, columns: columns)

            CalendarMonthGrid(
                dates: monthDates,
                columns: columns,
                selectedDate: selectedDate,
                calendar: calendar,
                eventCount: eventCount(on:),
                onSelectDate: { selectedDate = $0 }
            )
        }

        selectedDaySection
    }

    @ViewBuilder
    private var selectedDaySection: some View {
        if selectedDayEvents.isEmpty {
            Section(selectedDate.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())) {
                Text("No events this day")
                    .foregroundStyle(.secondary)
            }
        } else {
            Section(selectedDate.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()).uppercased()) {
                ForEach(selectedDayEvents) { event in
                    eventRow(event)
                }
            }
        }
    }

    private func eventCount(on date: Date) -> Int {
        events.filter { calendar.isDate($0.nextDate, inSameDayAs: date) }.count
    }

    private func moveDisplayedMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) else { return }
        displayedMonth = newMonth

        if let monthInterval = calendar.dateInterval(of: .month, for: newMonth),
           !monthInterval.contains(selectedDate) {
            selectedDate = monthInterval.start
        }
    }
}
