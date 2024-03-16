//
// File: OutlineItemNodeNotes.swift
// Package: Outline Tester
// Created by: Steven Barnett on 16/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineItemNodeNotes: View {
    
    @EnvironmentObject var vm: MainViewModel
    @AppStorage(Constants.previewLineCount) var previewLineCount: Int = 1

    @ObservedObject var node: OutlineItem
    
    var body: some View {
        if !node.notes.isEmpty {
            Text(node.notes)
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
