//
//  Fonts.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/17/26.
//

import SwiftUI

extension Font {
    static let displaySerif = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let eyebrow = Font.system(.caption, design: .monospaced).weight(.semibold)
    static let cardTitle = Font.system(.headline, design: .serif)
    static let cardMeta = Font.system(.subheadline, design: .monospaced)
    static let italicNote = Font.system(.callout, design: .serif).italic()
}
