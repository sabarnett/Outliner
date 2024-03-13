//
// File: TreeFind.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TreeFind {
    
    var foundNode: OutlineItem?
    
    mutating func find(inTree tree: OutlineItem?, withKey key: UUID) -> OutlineItem? {

        if let rootNode = tree, rootNode.hasChildren {
            for child in rootNode.children {
                if child.id == key { return child }
                
                findInTree(node: child, withKey: key)
                if foundNode != nil { return foundNode }
            }
        }
        
        return foundNode
    }
    
    mutating private func findInTree(node: OutlineItem, withKey key: UUID) {

        // Unwind the recursion if the item was found.
        if foundNode != nil { return }

        if node.hasChildren {
            for child in node.children {
                if child.id == key {
                    foundNode = child
                    return
                }
                findInTree(node: child, withKey: key)
            }
        }
    }
}
