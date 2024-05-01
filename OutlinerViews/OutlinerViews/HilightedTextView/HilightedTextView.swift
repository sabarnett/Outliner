//
// File: HilightedTextView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 10/04/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct HilightedTextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(text: String, highlight: String) {
        self.text = text
        self.highlight = highlight
    }
    
    let text: String
    let highlight: String
    
    public var body: some View {
        Text(highlightedText)
    }
    
    private var highlightedText: AttributedString {
        let highlightColor = colorScheme == .light ? Color.yellow : Color.yellow.opacity(0.4)
        var result = AttributedString(text)

        let ranges = text.ranges(of: highlight, options: [.caseInsensitive])
        ranges.forEach { range in
            result[range].backgroundColor = highlightColor
            result[range].inlinePresentationIntent = .stronglyEmphasized
        }

        // 5.
        return result
    }
}

#Preview {
    HilightedTextView(text: "Hello Steve, how are you steve?",
        highlight: "steve")
}
