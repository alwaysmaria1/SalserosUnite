//
//  PlaceholderView.swift
//  Salseros_App
//
//  Created by Noelia Herne on 7/6/26.
//
// Simple placeholder screen for unfinished tabs.
import SwiftUI
 
struct PlaceholderView: View {
    let title: String
    let message: String
 
    var body: some View {
        NavigationStack {
            Text(message)
                .font(.cardMeta)
                .foregroundStyle(Color.mutedIvory)
                .navigationTitle(title)
        }
        .espressoBackground()
    }
}
