//
//  FlowChipLayout.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Shared chip layout and tag chip components.

import SwiftUI

struct FlowChipLayout<Content: View>: View {
    var horizontalSpacing: CGFloat = 8
    var verticalSpacing: CGFloat = 8
    @ViewBuilder let content: Content

    var body: some View {
        WrappingChipLayout(horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing) {
            content
        }
    }
}

private struct WrappingChipLayout: Layout {
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        let rows = arrangedRows(for: subviews, maxWidth: maxWidth)
        let width = rows.map(\.width).max() ?? 0
        let height = rows.reduce(CGFloat.zero) { total, row in
            total + row.height
        } + CGFloat(max(0, rows.count - 1)) * verticalSpacing

        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let rows = arrangedRows(for: subviews, maxWidth: bounds.width)
        var y = bounds.minY

        for row in rows {
            var x = bounds.minX

            for item in row.items {
                subviews[item.index].place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(item.size)
                )
                x += item.size.width + horizontalSpacing
            }

            y += row.height + verticalSpacing
        }
    }

    private func arrangedRows(for subviews: Subviews, maxWidth: CGFloat) -> [ChipRow] {
        var rows: [ChipRow] = []
        var currentItems: [ChipItem] = []
        var currentWidth: CGFloat = 0
        var currentHeight: CGFloat = 0

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let spacing = currentItems.isEmpty ? 0 : horizontalSpacing
            let wouldExceedWidth = currentWidth + spacing + size.width > maxWidth

            if wouldExceedWidth && !currentItems.isEmpty {
                rows.append(ChipRow(items: currentItems, width: currentWidth, height: currentHeight))
                currentItems = []
                currentWidth = 0
                currentHeight = 0
            }

            let itemSpacing = currentItems.isEmpty ? 0 : horizontalSpacing
            currentItems.append(ChipItem(index: index, size: size))
            currentWidth += itemSpacing + size.width
            currentHeight = max(currentHeight, size.height)
        }

        if !currentItems.isEmpty {
            rows.append(ChipRow(items: currentItems, width: currentWidth, height: currentHeight))
        }

        return rows
    }

    private struct ChipRow {
        let items: [ChipItem]
        let width: CGFloat
        let height: CGFloat
    }

    private struct ChipItem {
        let index: Int
        let size: CGSize
    }
}

struct TagChip: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.eyebrow)
            .foregroundStyle(Color.ivory)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.teal, in: Capsule())
    }
}
