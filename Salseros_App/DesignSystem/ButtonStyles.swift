//
//  ButtonStyles.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
import SwiftUI

//Customer Buttonstyle
struct PillActionStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.eyebrow)
            .foregroundStyle(Color.ivory)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.teal))
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct OutlinePillStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.eyebrow)
            .foregroundStyle(Color.teal)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .stroke(Color.teal, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
