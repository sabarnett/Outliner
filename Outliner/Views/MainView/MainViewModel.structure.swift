//
// File: MainViewModel.structure.swift
// Package: Outline Tester
// Created by: Steven Barnett on 09/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import SwiftUI

extension MainViewModel {
    
    @MainActor
    func move(_ source: OutlineItem, to targetNode: OutlineItem, inserting: NodeMoveRelativeTo) {
        let mover = NodeMover()
        mover.move(source, to: targetNode, inserting: inserting, inTree: self.tree!)
        
        DispatchQueue.main.async {
            if inserting == .child {
                targetNode.setExpansionState(to: .expanded)
            }
            
            self.objectWillChange.send()
        }
    }
    
    func canIndent(item: OutlineItem? = nil) -> Bool {
        let testItem = item ?? selection
        guard let testItem,
              let parent = testItem.parent else { return false }
        
        let selectionIndex = parent.children.firstIndex(where: {$0.id == testItem.id}) ?? 0
        return selectionIndex > 0
    }
    
    @MainActor func indentSelection() {
        guard let selection,
              let parent = selection.parent,
              let selectionIndex = parent.children.firstIndex(where: {$0.id == selection.id})
        else { return }
        
        let target = parent.children[selectionIndex-1]
        move(selection, to: target, inserting: .child)
    }
    
    func canPromote(item: OutlineItem? = nil) -> Bool {
        let testItem = item ?? selection
        guard let testItem,
              let tree,
              let parent = testItem.parent else { return false }
        
        return parent.id != tree.id
    }
    
    @MainActor func promoteSelection() {
        guard let selection,
              let parent = selection.parent else { return }

        move(selection, to: parent, inserting: .below)
    }
}
