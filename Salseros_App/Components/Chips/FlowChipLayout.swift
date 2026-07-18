//
//  FlowChipLayout.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Shared chip layout and tag chip components.

import SwiftUI

struct FlowChipLayout<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                content
            }

            VStack(alignment: .leading) {
                content
            }
        }
    }
}

struct TagChip: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.thinMaterial, in: Capsule())
    }
}
