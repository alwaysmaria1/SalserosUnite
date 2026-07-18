//
//  CalendarMonthHeader.swift
//  Salseros_App
//
// Header controls for changing the visible calendar month.

import SwiftUI

struct CalendarMonthHeader: View {
    let title: String
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void

    var body: some View {
        HStack {
            Button {
                onPreviousMonth()
            } label: {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Previous month")

            Spacer()

            Text(title)
                .font(.headline)

            Spacer()

            Button {
                onNextMonth()
            } label: {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Next month")
        }
    }
}
