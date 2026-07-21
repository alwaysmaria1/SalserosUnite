//
//  ProfileRoleBadge.swift
//  Salseros_App
//
// Circular shoe portrait plus role label for the user's dancing role.
//

import SwiftUI

struct ProfileRoleBadge: View {
    let role: DanceRole

    var body: some View {
        VStack(spacing: 12) {
            Image(role.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.ivory.opacity(0.35), lineWidth: 1)
                )

            Text(role.rawValue.uppercased())
                .font(.eyebrow)
                .tracking(4)
                .foregroundStyle(Color.ivory)
        }
    }
}

#Preview {
    ProfileRoleBadge(role: .lead)
        .padding()
        .background(Color.espresso)
}
