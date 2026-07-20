//
//  MeasuringTapeDivider.swift
//  Salseros_App
//
//  Reusable measuring tape divider.

import SwiftUI

struct MeasuringTapeDivider: View {
    private let tickCount = 24

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tickCount, id: \.self) { index in
                Rectangle()
                    .fill(Color.ink.opacity(0.46))
                    .frame(width: 1, height: index.isMultiple(of: 2) ? 12 : 6)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 18)
        .background(Color(red: 0.86, green: 0.73, blue: 0.52))
        .shadow(color: Color.ink.opacity(0.16), radius: 5, x: 0, y: 2)
    }
}
