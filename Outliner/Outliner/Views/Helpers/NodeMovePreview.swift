//
// File: NodeMovePreview.swift
// Package: Outline Tester
// Created by: Steven Barnett on 14/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerFile

struct NodeMovePreview: View {
    
    var node: OutlineItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(node.text).font(.system(size: 30)).bold()
            Text(node.notes).font(.system(size: 22))
                .lineLimit(3)
        }.frame(maxWidth: 400, alignment: .leading)
    }
}

#Preview {
    NodeMovePreview(node: OutlineItem.example)
}
