//
//  FittingDetailsView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Form for entering or editing fitting details.

import SwiftUI

//The screen where a user logs a fitting for a specific event
struct FittingDetailsView: View {
    let event: Event
    let mode: FittingMode
    @Binding var date: Date
    @Binding var verdict: Verdict
    @Binding var vibeTags: Set<Vibe>
    @Binding var danceStylesTonight: Set<DanceStyle>
    @Binding var difficulties: Set<Difficulty>
    @Binding var leadFollowRatio: LeadFollowRatio
    @Binding var note: String
    let onCancel: () -> Void
    let onSave: () -> Void

    @State private var selectedDateChip: DateChip = .tonight
    @State private var didRate = false
    @State private var expandedDetailSection: FittingDetailSection?

    private var eventTitle: String {
        event.venue?.name ?? event.name
    }

    private var eventSubtitle: String {
        event.venue == nil ? "" : event.name
    }

    private var ratingExplanation: String {
        switch verdict {
        case .rack:
            return "Fine. Nothing special, but you showed up."
        case .altered:
            return "Better than expected. A few good moments."
        case .toMeasure:
            return "Really good. You'd go back without thinking twice."
        case .bespoke:
            return "Perfect fit. One of the best nights out."
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                dragHandle
                    .padding(.top, 10)
                    .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 18) {
                    header
                    ratingPanel

                    if didRate || mode == .edit {
                        detailsReceipt
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 18)
                .padding(.bottom, 96)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.cardCream)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28))
            }

            saveBar
        }
        .espressoBackground()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            didRate = mode == .edit
        }
    }

    private var dragHandle: some View {
        Capsule()
            .fill(Color.ink.opacity(0.3))
            .frame(width: 64, height: 6)
            .frame(maxWidth: .infinity)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("LOG A FITTING")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ink)

                VStack(alignment: .leading, spacing: 4) {
                    Text(eventTitle)
                        .font(.cardTitle)
                        .foregroundStyle(Color.ink)
                        .lineLimit(1)

                    if !eventSubtitle.isEmpty {
                        Text(eventSubtitle)
                            .font(.eyebrow)
                            .foregroundStyle(Color.ink.opacity(0.62))
                            .lineLimit(1)
                    }
                }
            }

            Spacer()

            Button(action: onCancel) {
                Image(systemName: "xmark")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.ink)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cancel fitting")
        }
    }

    private var ratingPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("HOW WAS THE NIGHT? *")
                .font(.eyebrow)
                .foregroundStyle(Color.ink)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
                ForEach(Verdict.allCases) { option in
                    Button {
                        verdict = option
                        didRate = true
                    } label: {
                        Text(ratingTitle(for: option))
                            .font(.caption2.weight(.bold))
                            .lineLimit(2)
                            .minimumScaleFactor(0.62)
                            .foregroundStyle(Color.ivory)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(verdict == option && didRate ? Color.rust : Color.teal, in: RoundedRectangle(cornerRadius: 7))
                            .overlay {
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(verdict == option && didRate ? Color.rust : Color.teal.opacity(0.9), lineWidth: 1)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }

            if didRate || mode == .edit {
                Text(ratingExplanation)
                    .font(.italicNote)
                    .foregroundStyle(Color.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.teal.opacity(0.5), style: StrokeStyle(lineWidth: 1.4, dash: [5, 4]))
                    }
            }
        }
        .padding(16)
        .background(Color.teal.opacity(0.34), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.teal.opacity(0.48), lineWidth: 1)
        }
    }

    private var detailsReceipt: some View {
        VStack(alignment: .leading, spacing: 14) {
            ReceiptDashedLine(color: Color.ink.opacity(0.25))

            expandableDetailRow(section: .date, title: "Date", summary: selectedDateChip.title) {
                choiceGrid {
                    ForEach(DateChip.allCases) { chip in
                        smallChoice(chip.title, isSelected: selectedDateChip == chip) {
                            selectDateChip(chip)
                        }
                    }
                }
            }

            expandableDetailRow(section: .difficulty, title: "Difficulty", summary: difficultySummary) {
                choiceGrid {
                    ForEach(Difficulty.allCases) { difficulty in
                        smallChoice(difficulty.shortTitle, isSelected: difficulties.contains(difficulty)) {
                            toggleDifficulty(difficulty)
                        }
                    }
                }
            }

            expandableDetailRow(section: .feel, title: "Feel", summary: vibeSummary) {
                choiceGrid {
                    ForEach(Vibe.filterCases) { vibe in
                        smallChoice(vibe.displayTitle, isSelected: vibeTags.contains(vibe)) {
                            toggleVibe(vibe)
                        }
                    }
                }
            }

            expandableDetailRow(section: .style, title: "Style", summary: danceStyleSummary) {
                choiceGrid {
                    ForEach(DanceStyle.allCases) { style in
                        smallChoice(style.id.replacingOccurrences(of: "Salsa (", with: "").replacingOccurrences(of: ")", with: ""), isSelected: danceStylesTonight.contains(style)) {
                            toggleDanceStyle(style)
                        }
                    }
                }
            }

            expandableDetailRow(section: .leadFollow, title: "Lead : Follow", summary: leadFollowRatio.rawValue) {
                choiceGrid {
                    ForEach(LeadFollowRatio.allCases) { ratio in
                        smallChoice(ratio.rawValue, isSelected: leadFollowRatio == ratio) {
                            leadFollowRatio = ratio
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 7) {
                Text("Notes")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(Color.ink)

                TextField("Add a note", text: $note, axis: .vertical)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.ink)
                    .lineLimit(2, reservesSpace: true)
                    .padding(10)
                    .background(Color.cardCream.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.ink.opacity(0.22), lineWidth: 1)
                    }
            }
        }
        .padding(16)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private var difficultySummary: String {
        selectedSummary(difficulties.map(\.shortTitle))
    }

    private var vibeSummary: String {
        selectedSummary(vibeTags.filter(\.isVisibleTag).map(\.displayTitle))
    }

    private var danceStyleSummary: String {
        selectedSummary(danceStylesTonight.map { $0.id.replacingOccurrences(of: "Salsa (", with: "").replacingOccurrences(of: ")", with: "") })
    }

    private func selectedSummary(_ values: [String]) -> String {
        guard !values.isEmpty else { return "Tap to choose" }
        let sortedValues = values.sorted()
        let visibleValues = sortedValues.prefix(2).joined(separator: ", ")
        let remainingCount = sortedValues.count - 2

        return remainingCount > 0 ? "\(visibleValues) +\(remainingCount)" : visibleValues
    }

    private func expandableDetailRow<Content: View>(
        section: FittingDetailSection,
        title: String,
        summary: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.snappy(duration: 0.18)) {
                    expandedDetailSection = expandedDetailSection == section ? nil : section
                }
            } label: {
                HStack(spacing: 10) {
                    Text(title)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.ink)

                    Spacer(minLength: 8)

                    Text(summary)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color.teal)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.ink.opacity(0.42))
                        .rotationEffect(.degrees(expandedDetailSection == section ? 90 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expandedDetailSection == section {
                content()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 2)
    }

    private func choiceGrid<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 7) {
            content()
        }
    }

    private func smallChoice(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption2.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .foregroundStyle(isSelected ? Color.ivory : Color.ink)
                .padding(.horizontal, 8)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.rust : Color.clear, in: RoundedRectangle(cornerRadius: 7))
                .overlay {
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(isSelected ? Color.rust : Color.rust.opacity(0.38), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }

    private var saveBar: some View {
        VStack(spacing: 10) {
            Button(action: onSave) {
                Text("SAVE FITTING")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.rust, in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!(didRate || mode == .edit))
            .opacity(didRate || mode == .edit ? 1 : 0.45)

            ReceiptDashedLine(color: Color.ink.opacity(0.28))
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .padding(.bottom, 14)
        .background(Color.cardCream.opacity(0.96))
    }

    private func ratingTitle(for option: Verdict) -> String {
        switch option {
        case .rack:
            "OFF THE RACK"
        case .altered:
            "ALTERED"
        case .toMeasure:
            "TO MEASURE"
        case .bespoke:
            "BESPOKE"
        }
    }

    private func selectDateChip(_ chip: DateChip) {
        selectedDateChip = chip

        switch chip {
        case .tonight:
            date = .now
        case .yesterday:
            date = Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now
        case .pickDate:
            break
        }
    }

    private func toggleVibe(_ vibe: Vibe) {
        if vibeTags.contains(vibe) {
            vibeTags.remove(vibe)
        } else {
            vibeTags.insert(vibe)
        }
    }

    private func toggleDanceStyle(_ style: DanceStyle) {
        if danceStylesTonight.contains(style) {
            danceStylesTonight.remove(style)
        } else {
            danceStylesTonight.insert(style)
        }
    }

    private func toggleDifficulty(_ difficulty: Difficulty) {
        if difficulties.contains(difficulty) {
            difficulties.remove(difficulty)
        } else {
            difficulties.insert(difficulty)
        }
    }
}

struct ReceiptDashedLine: View {
    let color: Color

    var body: some View {
        Line()
            .stroke(color, style: StrokeStyle(lineWidth: 1.4, dash: [6, 6]))
            .frame(height: 1)
    }

    private struct Line: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            return path
        }
    }
}

enum FittingMode {
    case create
    case edit

    var title: String {
        switch self {
        case .create:
            "New Fitting"
        case .edit:
            "Edit Fitting"
        }
    }
}

private enum FittingDetailSection: Hashable {
    case date
    case difficulty
    case feel
    case style
    case leadFollow
}

private enum DateChip: String, CaseIterable, Identifiable {
    case tonight
    case yesterday
    case pickDate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tonight:
            "Tonight"
        case .yesterday:
            "Yesterday"
        case .pickDate:
            "Pick"
        }
    }
}
