//
// File: NodeList.swift
// Package: Outliner
// Created by: Steven Barnett on 05/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import OutlinerFile

struct NodeList {
    private var childNodes: [OutlineItem] = []
    
    public mutating func listNodeAndChildren(from startNode: OutlineItem) -> [OutlineItem] {
        addChildNodes(startNode)
        return childNodes
    }
    
    private mutating func addChildNodes(_ startNode: OutlineItem) {
        childNodes.append(startNode)
        
        for child in startNode.children {
            addChildNodes(child)
        }
    }
}
