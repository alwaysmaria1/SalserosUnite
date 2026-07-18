//
//  CalendarMonthGrid.swift
//  Salseros_App
//
// Month grid that renders selectable calendar day cells.

import SwiftUI

struct CalendarMonthGrid: View {
    let dates: [Date?]
    let columns: [GridItem]
    let selectedDate: Date
    let calendar: Calendar
    let eventCount: (Date) -> Int
    let onSelectDate: (Date) -> Void

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(dates.enumerated()), id: \.offset) { _, date in
                if let date {
                    CalendarDayButton(
                        date: date,
                        eventCount: eventCount(date),
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isToday: calendar.isDateInToday(date)
                    ) {
                        onSelectDate(date)
                    }
                } else {
                    Color.clear
                        .frame(height: 44)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
