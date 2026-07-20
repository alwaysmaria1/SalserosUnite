//
//  AvatarStack.swift
//  Salseros_App
//
// Shared overlapped initials stack for friends/attendees.

import SwiftUI

struct AvatarStack: View {
    let names: [String]
    var maxCount = 3
    var size: CGFloat = 34
    var overlap: CGFloat = -8
    var font: Font = .eyebrow
    var strokeColor: Color = Color.cardCream
    var palette: [Color] = [Color.teal, Color.rust, Color.ink]

    var body: some View {
        HStack(spacing: overlap) {
            ForEach(Array(names.prefix(maxCount).enumerated()), id: \.offset) { index, name in
                Text(initials(for: name))
                    .font(font)
                    .foregroundStyle(Color.ivory)
                    .frame(width: size, height: size)
                    .background(color(at: index), in: Circle())
                    .overlay {
                        Circle()
                            .stroke(strokeColor, lineWidth: 2)
                    }
            }
        }
    }

    private func initials(for name: String) -> String {
        let initials = name
            .split(separator: " ")
            .compactMap(\.first)
            .prefix(2)
            .map(String.init)
            .joined()

        return initials.isEmpty ? "?" : initials
    }

    private func color(at index: Int) -> Color {
        guard !palette.isEmpty else { return Color.ink }
        return palette[index % palette.count]
    }
}
