//
// File: OutlineItemNodeNotes.swift
// Package: Outline Tester
// Created by: Steven Barnett on 16/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerViews

struct OutlineItemNodeNotes: View {
    
    @EnvironmentObject var vm: MainViewModel
    @AppStorage(Constants.previewLineCount) var previewLineCount: Int = 1

    @ObservedObject var node: OutlineItem
    
    var body: some View {
        if !node.notes.isEmpty {
            HilightedTextView(text: node.notes, highlight: vm.searchFor)
                .lineLimit(0...previewLineCount)
                .themedFont(for: .itemNotes)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    OutlineItemNodeNotes(node: OutlineItem.example)
}
