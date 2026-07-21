//
//  SwatchRow.swift
//  Salseros_App
//
// A single row in the Swatch Book: venue on the left, verdict label on the right,
// full-bleed background tinted by the verdict's swatch color.
//

import SwiftUI

struct SwatchRow: View {
    let venueName: String
    let verdict: Verdict
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                Text(venueName)
                    .font(.cardTitle)
                    .foregroundStyle(verdict.swatchForegroundColor)
                    .lineLimit(1)

                Spacer(minLength: 12)

                Text(verdict.rawValue.lowercased())
                    .font(.italicNote)
                    .foregroundStyle(verdict.swatchForegroundColor.opacity(0.78))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(verdict.swatchColor, in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        SwatchRow(venueName: "LR Studio", verdict: .bespoke, action: {})
        SwatchRow(venueName: "El Maestro", verdict: .toMeasure, action: {})
        SwatchRow(venueName: "Moe's Cantina", verdict: .altered, action: {})
        SwatchRow(venueName: "Drink Nightclub", verdict: .rack, action: {})
    }
    .background(Color.espresso)
}
