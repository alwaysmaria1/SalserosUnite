//
//  ProfileStatColumn.swift
//  Salseros_App
//
// Single stat cell (big number over a caption) used in the profile stats row.
//

import SwiftUI

struct ProfileStatColumn: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 10) {
            Text("\(value)")
                .font(.system(.largeTitle, design: .serif).weight(.bold))
                .foregroundStyle(Color.ivory)

            Rectangle()
                .fill(Color.ivory.opacity(0.32))
                .frame(width: 28, height: 1)

            Text(label.uppercased())
                .font(.eyebrow)
                .tracking(3)
                .foregroundStyle(Color.ivory.opacity(0.72))
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

#Preview {
    HStack(spacing: 0) {
        ProfileStatColumn(value: 2, label: "Nights")
        ProfileStatColumn(value: 2, label: "Venues")
    }
    .padding()
    .background(Color.espresso)
}
