//
// File: TreeStats.swift
// Package: Outline Tester
// Created by: Steven Barnett on 18/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

struct TreeStats {
    
    var nodeCount: Int = 0
    var starredCount: Int = 0
    var completeCount: Int = 0
    var incompleteCount: Int {
        nodeCount - completeCount
    }
    
    mutating func calculate(forTree tree: OutlineItem?) {
        nodeCount = 0
        starredCount = 0
        completeCount = 0
        
        if let rootNode = tree, rootNode.hasChildren {
            for child in rootNode.children {
                calculateStats(node: child)
            }
        }
    }
    
    mutating private func calculateStats(node: OutlineItem) {

        nodeCount += 1
        starredCount += node.starred ? 1 : 0
        completeCount += node.completed ? 1 : 0
        
        if node.hasChildren {
            for child in node.children {
                calculateStats(node: child)
            }
        }
    }
}
