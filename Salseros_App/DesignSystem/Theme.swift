//
//  Theme.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//

import SwiftUI

//SSOT for colors throughout the app
extension Color {
    static let espresso = Color(red: 0.55, green: 0.39, blue: 0.25)  // ~#8C633F
    static let ivory = Color(red: 0.95, green: 0.91, blue: 0.85)     // ~#F1E8D8
    static let teal = Color(red: 0.18, green: 0.36, blue: 0.35)      // ~#2F5D5A
    static let rust = Color(red: 0.72, green: 0.42, blue: 0.20)      // adjust to taste
    static let ink = Color(red: 0.06, green: 0.10, blue: 0.18)       // ~#101A2E
    static let mutedIvory = Color.ivory.opacity(0.6)
    static let cardCream = Color(red: 0.97, green: 0.94, blue: 0.88)
    static let mutedEspresso = Color(red: 0.32, green: 0.22, blue: 0.14)
}

//Swatch book palette – each verdict earns a color that becomes its "swatch".
extension Verdict {
    var swatchColor: Color {
        switch self {
        case .bespoke:
            .teal
        case .toMeasure:
            .cardCream
        case .altered:
            .rust
        case .rack:
            .mutedEspresso
        }
    }

    var swatchForegroundColor: Color {
        switch self {
        case .toMeasure:
            .ink
        case .bespoke, .altered, .rack:
            .ivory
        }
    }
}
