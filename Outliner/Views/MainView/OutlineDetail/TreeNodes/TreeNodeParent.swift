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
        } label: {
            Group {
                OutlineItemView(node: node)
                    .onDrag {
                        node.providerEncode()
                    }
            }
            
            // Called when we drop onto a parent node - a disclosure group.
            .onDrop(of: [.text], delegate: self)
        }
    }
}

extension TreeNodeParent: DropDelegate {

    func dropEntered(info: DropInfo) {
        isTargeted = true
    }
    
    func dropExited(info: DropInfo) {
        isTargeted = false
    }
    
    func validateDrop(info: DropInfo) -> Bool {
        info.itemProviders(for: [.text]).count >  0 ? true : false
    }
    
    func performDrop(info: DropInfo) -> Bool {
        // We dropped on a parent node (a disclosure group). The user is asking to move a node
        // as a child of the parent. Perform some checks that this is a valid move, then we
        // shift the node to the current parent fom it's original parent.
        let targetNode = node
        if let sourceItem = info.itemProviders(for: [.text]).first {
            _ = sourceItem.loadObject(ofClass: String.self) { key, _ in
                // we have the key of the source node, go find it in the tree
                let sourceKey = UUID(uuidString: key!)!
                if let sourceNode = vm.tree?.findById(sourceKey) {
                    let mover = NodeMover()
                    mover.move(sourceNode, to: targetNode, inserting: .child, inTree: vm.tree!)
//                    WriteLog.debug("Move ", sourceNode.text, " as a child of ", targetNode.text)
                }
            }
        }
        return true
    }
}
