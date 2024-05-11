//
// File: NodeMover.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerViews
import OutlinerFile

enum NodeMoveRelativePosition: String {
    case above
    case below
    case child
}

/// Helper struct used to aid when moving nodes in the tree structure. It performs
/// basic sanity checking to ensure that the move is valid, then adjusts the
/// position of the node or the herarchy leg if there are child nodes.
struct NodeMover {
    
    /// Move a node/branch in the tree to another place.
    ///
    /// - Parameters:
    ///   - source: The node or the head of a branch to be moved
    ///   - target: The node we want to insert relative to
    ///   - inserting: The relatove position of the insertion
    ///   - inTree: The tree we want to insert into
    ///
    func move(_ source: OutlineItem, to target: OutlineItem, inserting position: NodeMoveRelativePosition, inTree: OutlineItem) {
        // Check 1: We cannot move to ourselves
        guard source.id != target.id else {
            DispatchQueue.main.async { Alerts.cannotMoveToYourself() }
            return
        }
        
        // Check 2: The target must not be a child of the source
        guard nodeHasParent(toMove: source, toMoveTo: target) == false else {
            DispatchQueue.main.async { Alerts.cannotMoveToDecendent() }
            return
        }
        
        switch position {
        case .above:
            moveAbove(source: source, target: target, tree: inTree)
        case .below:
            moveBelow(source: source, target: target, tree: inTree)
        case .child:
            moveChild(source: source, target: target, tree: inTree)
        }
    }
    
    fileprivate func moveAbove(source: OutlineItem, target: OutlineItem, tree: OutlineItem) {
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
    }
    
    fileprivate func moveBelow(source: OutlineItem, target: OutlineItem, tree: OutlineItem) {
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
    }

    fileprivate func moveChild(source: OutlineItem, target: OutlineItem, tree: OutlineItem) {
        if disconnect(source: source) {
            target.children.insert(source, at: 0)
            source.parent = target
            source.hasChanged = true
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
