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

    private var nightSummary: String {
        "Night 2 • \(venueName)"
    }

    var body: some View {
        ZStack {
            Color.espresso
                .ignoresSafeArea()

            VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 22) {
                achievementBadge

                VStack(spacing: 12) {
                    Text(titleText)
                        .font(.system(size: 42, weight: .semibold, design: .serif).italic())
                        .foregroundStyle(Color.ivory)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 8) {
                        Text(nightSummary)
                            .font(.headline.weight(.bold))

                        Text("stitched into your wardrobe")
                            .font(.subheadline.weight(.bold))
                    }
                    .foregroundStyle(Color.ivory)
                    .multilineTextAlignment(.center)
                }
            }
            .padding(.bottom, 72)

            Spacer()

            Button {
                onDone()
            } label: {
                Text("DONE")
                    .font(.eyebrow)
                    .tracking(2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
            }
            .foregroundStyle(Color.ivory)
            .background(Color.teal)
            .buttonStyle(.plain)
            .padding(.horizontal, 40)
            .padding(.bottom, 52)
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .espressoBackground()
        }
    }

    private var achievementBadge: some View {
        ZStack {
            Circle()
                .fill(Color.espresso.opacity(0.62))
                .frame(width: 156, height: 156)

            Image("dancing")
                .resizable()
                .scaledToFit()
                .padding(28)
                .frame(width: 156, height: 156)
        }
        .overlay {
            Circle()
                .stroke(Color.teal, lineWidth: 4)
        }
    }
}
