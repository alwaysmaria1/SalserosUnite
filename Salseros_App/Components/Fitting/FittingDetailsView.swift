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

    private var eventTitle: String {
        event.venue?.name ?? event.name
    }

    private var eventSubtitle: String {
        event.venue == nil ? "" : event.name
    }

    private var ratingValue: Int {
        switch verdict {
        case .rack:
            return 1
        case .altered:
            return 2
        case .toMeasure:
            return 3
        case .bespoke:
            return 4
        }
    }

    private var ratingExplanation: String {
        switch verdict {
        case .rack:
            return "Easy night, no special prep needed."
        case .altered:
            return "A good fit with a few adjustments."
        case .toMeasure:
            return "Worth planning around next time."
        case .bespoke:
            return "Tailor-made for your best night out."
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                floatingEventName

                VStack(alignment: .leading, spacing: 18) {
                    dragHandle
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
                .padding(.bottom, 118)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.espresso)
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

    private var floatingEventName: some View {
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
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, -16)
        .zIndex(1)
    }

    private var dragHandle: some View {
        Capsule()
            .fill(Color.ivory.opacity(0.72))
            .frame(width: 64, height: 6)
            .frame(maxWidth: .infinity)
    }

    private var header: some View {
        HStack {
            Text("LOG A FITTING")
                .font(.eyebrow)
                .foregroundStyle(Color.ivory)

            Spacer()

            Button(action: onCancel) {
                Image(systemName: "xmark")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.ivory)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cancel fitting")
        }
    }

    private var ratingPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("HOW WAS THE NIGHT? *")
                .font(.eyebrow)
                .foregroundStyle(Color.ivory)

            HStack(spacing: 14) {
                ForEach(1...4, id: \.self) { value in
                    Button {
                        setRating(value)
                    } label: {
                        Image(systemName: value <= ratingValue && didRate ? "star.fill" : "star")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundStyle(value <= ratingValue && didRate ? Color.rust : Color.ivory.opacity(0.62))
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity)

            if didRate || mode == .edit {
                Text(ratingExplanation)
                    .font(.italicNote)
                    .foregroundStyle(Color.ivory.opacity(0.82))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.rust.opacity(0.8), style: StrokeStyle(lineWidth: 1.4, dash: [5, 4]))
                    }
            }
        }
        .padding(16)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.ivory.opacity(0.35), lineWidth: 1)
        }
    }

    private var detailsReceipt: some View {
        VStack(alignment: .leading, spacing: 14) {
            ReceiptDashedLine(color: Color.ink.opacity(0.25))

            compactRow(title: "Date") {
                HStack(spacing: 8) {
                    ForEach(DateChip.allCases) { chip in
                        smallChoice(chip.title, isSelected: selectedDateChip == chip) {
                            selectDateChip(chip)
                        }
                    }
                }
            }

            compactRow(title: "Difficulty") {
                HStack(spacing: 8) {
                    ForEach(Difficulty.allCases) { difficulty in
                        smallChoice(difficulty.shortTitle, isSelected: difficulties.contains(difficulty)) {
                            toggleDifficulty(difficulty)
                        }
                    }
                }
            }

            compactRow(title: "Feel") {
                HStack(spacing: 8) {
                    ForEach(Vibe.allCases.prefix(4)) { vibe in
                        smallChoice(vibe.rawValue, isSelected: vibeTags.contains(vibe)) {
                            toggleVibe(vibe)
                        }
                    }
                }
            }

            compactRow(title: "Style") {
                HStack(spacing: 8) {
                    ForEach(DanceStyle.allCases) { style in
                        smallChoice(style.id.replacingOccurrences(of: "Salsa (", with: "").replacingOccurrences(of: ")", with: ""), isSelected: danceStylesTonight.contains(style)) {
                            toggleDanceStyle(style)
                        }
                    }
                }
            }

            compactRow(title: "Lead : Follow") {
                HStack(spacing: 8) {
                    ForEach(LeadFollowRatio.allCases) { ratio in
                        smallChoice(ratio.rawValue, isSelected: leadFollowRatio == ratio) {
                            leadFollowRatio = ratio
                        }
                    }
                }
            }

            TextField("Add a note", text: $note, axis: .vertical)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.ink)
                .lineLimit(2, reservesSpace: true)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.rust.opacity(0.35), style: StrokeStyle(lineWidth: 1.2, dash: [5, 4]))
                }
        }
        .padding(16)
        .background(Color.cardCream, in: RoundedRectangle(cornerRadius: 8))
    }

    private func compactRow<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption2.weight(.bold))
                .foregroundStyle(Color.rust)

            content()
        }
    }

    private func smallChoice(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption2.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .foregroundStyle(isSelected ? Color.ivory : Color.ink.opacity(0.82))
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
        VStack(spacing: 14) {
            Button(action: onSave) {
                Text("SAVE FITTING")
                    .font(.eyebrow)
                    .foregroundStyle(Color.ivory)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.ink, in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!(didRate || mode == .edit))
            .opacity(didRate || mode == .edit ? 1 : 0.45)

            HStack(spacing: 12) {
                ReceiptDashedLine(color: Color.ivory.opacity(0.5))
                Text("SALSALOG · GOING TO THE TAILOR")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.ivory.opacity(0.62))
                    .lineLimit(1)
                ReceiptDashedLine(color: Color.ivory.opacity(0.5))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 16)
        .background(Color.espresso.opacity(0.94))
    }

    private func setRating(_ value: Int) {
        didRate = true

        switch value {
        case 1:
            verdict = .rack
        case 2:
            verdict = .altered
        case 3:
            verdict = .toMeasure
        default:
            verdict = .bespoke
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
