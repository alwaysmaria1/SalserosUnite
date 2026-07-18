//
//  CalendarWeekdayHeader.swift
//  Salseros_App
//
// Weekday labels for the calendar grid.

import SwiftUI

struct CalendarWeekdayHeader: View {
    let weekdaySymbols: [String]
    let columns: [GridItem]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol.prefix(1))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
