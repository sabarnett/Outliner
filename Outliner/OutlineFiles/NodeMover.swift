//
// File: NodeMover.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum NodeMoveRelativeTo {
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
            WriteLog.debug("Moving ", source.text, " above ", target.text)
        case .below:
            WriteLog.debug("Moving ", source.text, " below ", target.text)
        case .child:
            WriteLog.debug("Moving ", source.text, " as a child of ", target.text)
        }
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
