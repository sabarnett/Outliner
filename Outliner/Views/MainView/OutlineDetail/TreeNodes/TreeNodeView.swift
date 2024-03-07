//
// File: TreeNodeView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 08/11/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TreeNodeView: View {
    
    @EnvironmentObject var vm: MainViewModel
    @ObservedObject var node: OutlineItem
    
    var body: some View {
        ForEach(node.children) { (childItem: OutlineItem) in
            Group {
                if childItem.hasChildren == false {
                    OutlineItemView(node: childItem)
//                        .onDrag {
//                            appModel.providerEncode(id: childItem.id)
//                        }
                } else {
                    TreeNodeParent(node: childItem)
                }
            }
        }
    }
}
