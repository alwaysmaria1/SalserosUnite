//
//  FittingFlowView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
// Owns the new/edit fitting flow, including saving and confirmation.

import SwiftUI
import SwiftData

struct FittingFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let event: Event
    private let fittingToEdit: Fitting?

    @State private var date = Date.now
    @State private var verdict: Verdict = .rack
    @State private var vibeTags: Set<Vibe> = []
    @State private var danceStylesTonight: Set<DanceStyle> = []
    @State private var note = ""
    @State private var confirmationFitting: Fitting?
    @State private var didPrepareDraft = false

    private var mode: FittingMode {
        fittingToEdit == nil ? .create : .edit
    }

    init(event: Event) {
        self.event = event
        self.fittingToEdit = nil
    }

    init(fitting: Fitting) {
        self.event = fitting.event
        self.fittingToEdit = fitting
    }

    var body: some View {
        NavigationStack {
            if let confirmationFitting {
                FittingConfirmationView(fitting: confirmationFitting) {
                    dismiss()
                }
            } else {
                FittingDetailsView(
                    event: event,
                    mode: mode,
                    date: $date,
                    verdict: $verdict,
                    vibeTags: $vibeTags,
                    danceStylesTonight: $danceStylesTonight,
                    note: $note,
                    onSave: saveFitting
                )
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .onAppear(perform: prepareDraft)
    }

    private func prepareDraft() {
        guard !didPrepareDraft else { return }
        didPrepareDraft = true

        guard let fittingToEdit else {
            date = .now
            verdict = .rack
            vibeTags = []
            danceStylesTonight = []
            note = ""
            return
        }

        date = fittingToEdit.date
        verdict = fittingToEdit.verdict
        vibeTags = fittingToEdit.vibeTags
        danceStylesTonight = fittingToEdit.danceStylesTonight
        note = fittingToEdit.note
    }

    private func saveFitting() {
        let fitting: Fitting

        if let fittingToEdit {
            fittingToEdit.date = date
            fittingToEdit.verdict = verdict
            fittingToEdit.vibeTags = vibeTags
            fittingToEdit.danceStylesTonight = danceStylesTonight
            fittingToEdit.note = note
            fitting = fittingToEdit
        } else {
            let newFitting = Fitting(
                date: date,
                event: event,
                verdict: verdict,
                vibeTags: vibeTags,
                danceStylesTonight: danceStylesTonight,
                note: note,
                loggedByName: UserProfile.currentUserDisplayName
            )
            modelContext.insert(newFitting)
            fitting = newFitting
        }

        try? modelContext.save()
        confirmationFitting = fitting
    }
}
