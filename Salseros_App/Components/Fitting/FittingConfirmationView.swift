//
//  FittingConfirmationView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Confirmation screen shown after saving a fitting.

import SwiftUI

//Once a user finishes a review/fitting
struct FittingConfirmationView: View {
    let fitting: Fitting
    let onDone: () -> Void

    private var venueName: String {
        fitting.event.venue?.name ?? "Unknown venue"
    }

    private var titleText: String {
        "a \(fitting.verdict.rawValue.lowercased()) night"
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 40)

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(.green)

            VStack(spacing: 10) {
                Text(titleText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(venueName)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Button {
                fitting.event.isFavorite = true
            } label: {
                Label("MAKE IT A STANDING ORDER", systemImage: "heart")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            Spacer()

            Button {
                onDone()
            } label: {
                Text("DONE")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
