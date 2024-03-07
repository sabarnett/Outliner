//
// File: TreeNodeParent.swift
// Package: Outline Tester
// Created by: Steven Barnett on 08/11/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TreeNodeParent: View {

    @EnvironmentObject var vm: MainViewModel
    @ObservedObject var node: OutlineItem
    
    var body: some View {
        DisclosureGroup(isExpanded: $node.isExpanded) {
            TreeNodeView(node: node)
        } label: {
            Group {
                OutlineItemView(node: node)
//                    .onDrag {
//                        appModel.providerEncode(id: item.id)
//                    }
            }
//            .onDrop(of: [.text], delegate: self)
        }
    }
}
