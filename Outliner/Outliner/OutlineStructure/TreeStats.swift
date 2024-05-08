//
// File: TreeStats.swift
// Package: Outline Tester
// Created by: Steven Barnett on 18/02/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import OutlinerFile

struct TreeStats {
    
    var nodeCount: Int = 0
    var starredCount: Int = 0
    var completeCount: Int = 0
    var incompleteCount: Int {
        nodeCount - completeCount
    }
    
    mutating func calculate(forTree tree: OpmlFile) {
        nodeCount = 0
        starredCount = 0
        completeCount = 0
        
        for item in tree {
            nodeCount += 1
            if item.starred { starredCount += 1 }
            if item.completed { completeCount += 1 }
        }
    }
}
