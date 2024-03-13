//
// File: NodeMover.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum NodeMoveRelativeTo: String {
    case above
    case below
    case child
}

struct NodeMover {
    
    /// Move a node/branch in the tree to another place.
    ///
    /// - Parameters:
    ///   - source: The node or the head of a branch to be moved
    ///   - target: The node we want to insert relative to
    ///   - inserting: The relatove position of the insertion
    ///   - inTree: The tree we want to insert into
    ///
    func move(_ source: OutlineItem, to target: OutlineItem, inserting position: NodeMoveRelativeTo, inTree: OutlineItem) {
        // Check 1: We cannot move to ourselves
        if source.id == target.id {
            DispatchQueue.main.async {
                Alerts.cannotMoveToYourself()
            }
            return
        }
        
        // Check 2: The target must not be a child of the source
        if nodeHasParent(toMove: source, toMoveTo: target) {
            DispatchQueue.main.async {
                Alerts.cannotMoveToDecendent()
            }
            return 
        }
        
        switch position {
        case .above:
            guard let parent = target.parent,
                  parent.children.firstIndex(where: { $0.id == target.id }) != nil
            else { return }

            if disconnect(source: source) {
                // Recalculate the index, as it might change when we disconnect the source
                let index = parent.children.firstIndex(where: { $0.id == target.id })!
                parent.children.insert(source, at: index)
                source.parent = parent
                source.hasChanged = true
            }
        case .below:
            guard let parent = target.parent,
                  parent.children.firstIndex(where: { $0.id == target.id }) != nil
            else { return }

            if disconnect(source: source) {
                // Recalculate the index, as it might change when we disconnect the source
                let index = parent.children.firstIndex(where: { $0.id == target.id })!
                parent.children.insert(source, at: index + 1)
                source.parent = parent
                source.hasChanged = true
            }
        case .child:
            if disconnect(source: source) {
                target.children.insert(source, at: 0)
                source.parent = target
                source.hasChanged = true

                DispatchQueue.main.async {
                    target.setExpansionState(to: .expanded)
                }
            }
        }
    }
    
    fileprivate func disconnect(source: OutlineItem) -> Bool {
        guard let parent = source.parent,
              let sourceIndex = parent.children.firstIndex(where: { $0.id == source.id})
        else { return false }

        parent.children.remove(at: sourceIndex)
        return true
    }
    
    fileprivate func nodeHasParent(toMove source: OutlineItem, toMoveTo target: OutlineItem) -> Bool {
        // Check whether the source node is somewhere up the hierarchy from
        // the target node.
        var child = target
        while child.parent != nil {
            if child.parent?.id == source.id { return true }
            child = child.parent!
        }
        return false
    }
}
