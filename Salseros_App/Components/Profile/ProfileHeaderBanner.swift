//
//  ProfileHeaderBanner.swift
//  Salseros_App
//
// Hero banner for the Profile screen: full-bleed image with the user's name
// and dancing tagline layered over a bottom gradient.
//

import SwiftUI

struct ProfileHeaderBanner: View {
    let name: String
    let tagline: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("Lead_Profile_background")
                .resizable()
                .aspectRatio(contentMode: .fill)

            LinearGradient(
                colors: [
                    Color.black.opacity(0),
                    Color.black.opacity(0.55),
                    Color.black.opacity(0.85)
                ],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 10) {
                Text(name.uppercased())
                    .font(.system(.largeTitle, design: .serif).weight(.bold))
                    .foregroundStyle(Color.ivory)

                Text(tagline)
                    .font(.eyebrow)
                    .tracking(2)
                    .foregroundStyle(Color.ivory.opacity(0.78))
            }
            .padding(.horizontal, 36)
            .padding(.bottom, 34)
        }
        .frame(height: 340)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

#Preview {
    ProfileHeaderBanner(name: "Nico", tagline: "DANCING ON2 SINCE 2024")
        .background(Color.espresso)
}
