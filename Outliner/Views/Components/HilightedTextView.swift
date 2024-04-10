//
// File: HilightedTextView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 10/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct HilightedTextView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let text: String
    let highlight: String
    
    var body: some View {
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

extension StringProtocol {

    func ranges<T: StringProtocol>(
        of stringToFind: T,
        options: String.CompareOptions = [],
        locale: Locale? = nil
    ) -> [Range<AttributedString.Index>] {

        var ranges: [Range<String.Index>] = []
        var attributedRanges: [Range<AttributedString.Index>] = []
        let attributedString = AttributedString(self)

        while let result = range(
            of: stringToFind,
            options: options,
            range: (ranges.last?.upperBound ?? startIndex)..<endIndex,
            locale: locale
        ) {
            ranges.append(result)
            let start = AttributedString.Index(result.lowerBound, within: attributedString)!
            let end = AttributedString.Index(result.upperBound, within: attributedString)!
            attributedRanges.append(start..<end)
        }
        return attributedRanges
    }
}
