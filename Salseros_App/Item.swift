//
//  Item.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/1/26.
//
// Original starter SwiftData item model kept for reference.

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
