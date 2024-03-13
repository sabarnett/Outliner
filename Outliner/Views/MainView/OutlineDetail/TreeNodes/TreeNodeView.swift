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
        ForEach(node.children, id: \.self) { (childItem: OutlineItem) in
            Group {
                if childItem.hasChildren == false {
                    OutlineItemView(node: childItem)
                        .onDrag {
                            childItem.providerEncode()
                        }
                } else {
                    TreeNodeParent(node: childItem)
                }
            }
        }
        // Called when we drag and drop an item between two nodes in the hierarchy.
        .onInsert(of: [.text]) { index, items in
            handleNodeDrop(index, items)
        }
    }
}

// MARK: - Drag and drop support
extension TreeNodeView {
    
    fileprivate func handleNodeDrop(_ index: Int, _ items: [NSItemProvider]) {
        var moveRelative: NodeMoveRelativeTo = .above
        var targetIndex = index
        
        if index >= node.children.count {
            moveRelative = .below
            targetIndex = node.children.count - 1
        }
        let targetNode = node.children[targetIndex]
        
        items.forEach { provider in
            _ = provider.loadObject(ofClass: String.self) { text, _ in
                providerDecode(loadedString: text).forEach { key in
                    // we have the key of the source node, go find it in the tree
                    let sourceKey = key
                    if let sourceNode = vm.tree?.findById(sourceKey) {
                        vm.move(sourceNode, to: targetNode, inserting: moveRelative)
                    }
                }
            }
        }
    }
    
    func providerDecode(loadedString: String?) -> [UUID] {
        guard let possibleStringOfNodeIds: String = loadedString as String? else {
            // Nothing dropped of the type we want.
            return []
        }

        // Convert the (possibly) comma separated list of node id's
        // into an array of node UUID's.
        let decodedItems: [UUID] = possibleStringOfNodeIds
            .split(separator: ",")
            .map { String($0) }
            .compactMap({ UUID(uuidString: $0)})
        
        return decodedItems
    }
}
