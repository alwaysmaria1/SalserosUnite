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
                        .foregroundStyle(isSelected ? Color.ivory : Color.rust)
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
                        .stroke(Color.rust, lineWidth: 1)
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
            return Color.rust.opacity(0.16)
        }

        return Color.cardCream
    }

    private var accessibilityLabel: String {
        let dateText = date.formatted(.dateTime.month(.wide).day().year())
        let eventText = eventCount == 1 ? "1 event" : "\(eventCount) events"
        return "\(dateText), \(eventText)"
    }
}
