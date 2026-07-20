//
//  EventTagChip.swift
//  Salseros_App
//
// Reusable event metadata tags for difficulty, vibe, dance style, and crowd notes.

import SwiftUI

struct EventDisplayTag: Identifiable {
    let title: String
    let style: EventTagStyle

    var id: String { "\(style)-\(title)" }
}

enum EventTagStyle {
    case difficulty
    case standard

    var backgroundColor: Color {
        switch self {
        case .difficulty:
            Color.rust
        case .standard:
            Color.teal
        }
    }

    var foregroundColor: Color {
        Color.ivory
    }
}

struct EventTagChip: View {
    let tag: EventDisplayTag
    var font: Font = .eyebrow
    var horizontalPadding: CGFloat = 10
    var verticalPadding: CGFloat = 6

    var body: some View {
        Text(tag.title)
            .font(font)
            .foregroundStyle(tag.style.foregroundColor)
            .lineLimit(1)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(tag.style.backgroundColor, in: Capsule())
    }
}
