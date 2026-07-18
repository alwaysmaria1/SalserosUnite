//
//  ViewModifiers.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//
import SwiftUI
//for the brown background

struct EspressoBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.espresso)
            .preferredColorScheme(.dark)
    }
}

extension View {
    func espressoBackground() -> some View {
        modifier(EspressoBackground())
    }
}
