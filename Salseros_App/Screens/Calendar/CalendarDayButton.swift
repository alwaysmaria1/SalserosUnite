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
                    .font(.cardMeta.weight(isSelected || isToday ? .bold : .regular))

                if eventCount > 0 {
                    Text("\(eventCount)")
                        .font(.eyebrow)
                        .foregroundStyle(Color.ivory)
                } else {
                    Text(" ")
                        .font(.eyebrow)
                }
            }
                        .foregroundStyle(isSelected ? Color.ivory : Color.ink)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                if isToday && !isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.95, green: 0.42, blue: 0.08), lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.teal
        }

        if eventCount > 0 {
            return Color(red: 0.95, green: 0.42, blue: 0.08).opacity(0.86)
        }

        return Color.cardCream
    }

    private var accessibilityLabel: String {
        let dateText = date.formatted(.dateTime.month(.wide).day().year())
        let eventText = eventCount == 1 ? "1 event" : "\(eventCount) events"
        return "\(dateText), \(eventText)"
    }
}
