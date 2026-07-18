//
//  FittingActionButton.swift
//  Salseros_App
//
// Shared plus-or-pencil button for adding or editing a fitting.

import SwiftUI

struct FittingActionButton: View {
    let userFitting: Fitting?
    let onAddFitting: () -> Void
    let onEditFitting: (Fitting) -> Void

    var body: some View {
        Button {
            handleTap()
        } label: {
            Image(systemName: iconName)
                .font(.title3)
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.accentColor)
        .accessibilityLabel(accessibilityLabel)
    }

    private var iconName: String {
        userFitting == nil ? "plus.circle.fill" : "pencil.circle.fill"
    }

    private var accessibilityLabel: String {
        userFitting == nil ? "Add fitting" : "Edit fitting"
    }

    private func handleTap() {
        if let userFitting {
            onEditFitting(userFitting)
        } else {
            onAddFitting()
        }
    }
}
