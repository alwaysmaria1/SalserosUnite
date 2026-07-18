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
    @Binding var note: String
    let onSave: () -> Void

    @State private var selectedDateChip: DateChip = .tonight
    @State private var showsDatePicker = false

    var body: some View {
        Form {
            eventSection
            dateSection
            verdictSection
            energySection
            danceStylesSection
            noteSection
            saveSection
        }
        .navigationTitle(mode.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var eventSection: some View {
        Section("Where did you dance?") {
            Text(event.logDisplayName)
        }
    }

    private var dateSection: some View {
        Section("Date") {
            HStack {
                ForEach(DateChip.allCases) { chip in
                    Button {
                        selectDateChip(chip)
                    } label: {
                        Text(chip.title)
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(selectedDateChip == chip ? .accentColor : .secondary)
                }
            }

            if showsDatePicker {
                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
            }
        }
    }

    private var verdictSection: some View {
        Section("How did it carry?") {
            Picker("Verdict", selection: $verdict) {
                ForEach(Verdict.allCases) { verdict in
                    Text(verdict.rawValue).tag(verdict)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var energySection: some View {
        Section("Vibe") {
            FlowChipLayout {
                ForEach(Vibe.allCases) { vibe in
                    Button {
                        toggleVibe(vibe)
                    } label: {
                        Text(vibe.rawValue)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(vibeTags.contains(vibe) ? .accentColor : .secondary)
                }
            }
        }
    }

    private var danceStylesSection: some View {
        Section("Dance styles felt tonight") {
            FlowChipLayout {
                ForEach(DanceStyle.allCases) { style in
                    Button {
                        toggleDanceStyle(style)
                    } label: {
                        Text(style.rawValue)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(danceStylesTonight.contains(style) ? .accentColor : .secondary)
                }
            }
        }
    }

    private var noteSection: some View {
        Section("Note") {
            ZStack(alignment: .topLeading) {
                if note.isEmpty {
                    Text("A note for future you - the band, the floor, who you danced with...")
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }

                TextEditor(text: $note)
                    .frame(minHeight: 120)
            }
        }
    }

    private var saveSection: some View {
        Section {
            Button {
                onSave()
            } label: {
                Text("SAVE FITTING")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func selectDateChip(_ chip: DateChip) {
        selectedDateChip = chip
        showsDatePicker = chip == .pickDate

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
            "Pick Date"
        }
    }
}
