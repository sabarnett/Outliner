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
    @State internal var isTargeted: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $node.isExpanded) {
            TreeNodeView(node: node)
                .padding(.leading, 8)
            
        } label: {
            Group {
                OutlineItemView(node: node)
                    .contextMenu(menuItems: {
                        ContextMenuItems(node: node)
                    })
                
            }
        }
    }
}
