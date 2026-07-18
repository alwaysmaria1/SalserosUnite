//
//  CalendarDayButton.swift
//  Salseros_App
//
// Tappable day cell for the calendar month grid.

import SwiftUI

struct CalendarDayButton: View {
    let date: Date
    let eventCount: Int
    let isSelected: Bool
    let isToday: Bool
    let onSelect: () -> Void

    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 3) {
                Text("\(dayNumber)")
                    .font(.subheadline.weight(isSelected || isToday ? .bold : .regular))

                if eventCount > 0 {
                    Text("\(eventCount)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(isSelected ? .white : Color.accentColor)
                } else {
                    Text(" ")
                        .font(.caption2)
                }
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                if isToday && !isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }

    private var backgroundColor: Color {
        if isSelected {
            return .accentColor
        }

        if eventCount > 0 {
            return Color.accentColor.opacity(0.12)
        }

        return Color.secondary.opacity(0.08)
    }

    private var accessibilityLabel: String {
        let dateText = date.formatted(.dateTime.month(.wide).day().year())
        let eventText = eventCount == 1 ? "1 event" : "\(eventCount) events"
        return "\(dateText), \(eventText)"
    }
}
