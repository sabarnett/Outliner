//
// File: TreeFilter.swift
// Package: Outline Tester
// Created by: Steven Barnett on 24/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TreeFilter {
    
    @AppStorage(Constants.recentFileFilters) var recentFileFilters: Int = 5
    
    func listNodes(ofType: DetailViewType, fromTree tree: OutlineItem?) -> [OutlineItem] {
        var result = [OutlineItem]()
        
        if let rootNode = tree, rootNode.hasChildren {
            for child in rootNode.children {
                filterItems(&result, node: child, ofType: ofType)
            }
        }
        
        return result
    }
    
    private func filterItems(_ matchingItems: inout [OutlineItem], node: OutlineItem, ofType: DetailViewType) {
        if shouldKeep(node, ofType) {
            matchingItems.append(node)
        }
        
        if node.hasChildren {
            for child in node.children {
                filterItems(&matchingItems, node: child, ofType: ofType)
            }
        }
    }
    
    private func shouldKeep(_ node: OutlineItem, _ ofType: DetailViewType) -> Bool {
        
        switch ofType {
        case .outline:
            return false
        case .completed:
            return node.completed
        case .incomplete:
            return !node.completed
        case .starred:
            return node.starred
        case .recentlyAdded:
            if let added = node.createdDate {                
                return abs(added.timeIntervalSinceNow) <  timeInterval
            }
        case .recentlyCompleted:
            if let completed = node.completedDate {
                return abs(completed.timeIntervalSinceNow) < timeInterval
            }
        case .recentlyUpdated:
            if let updated = node.updatedDate {
                return abs(updated.timeIntervalSinceNow) < timeInterval
            }
        }
        return false
    }
    
    private var timeInterval: Double {
        //                          Mins,Hrs, Days
        Double(recentFileFilters) * 60 * 60 * 24
    }
}
