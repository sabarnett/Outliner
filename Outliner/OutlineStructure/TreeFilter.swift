//
// File: TreeFilter.swift
// Package: Outline Tester
// Created by: Steven Barnett on 24/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TreeFilterOptions {
    var searchFor: String = ""
    var searchFields: SearchAppliesTo = .titleAndNotes
    var typeFilter: DetailViewType = .outline
    
    var hasTextFilter: Bool { !searchFor.isEmpty }
}

struct TreeFilter {
    
    @AppStorage(Constants.durationForRecentFilters) var recentDuration: Int = 5
    
    func listNodes(fromTree tree: OutlineItem?, withOptions options: TreeFilterOptions) -> [OutlineItem] {
        
        var result = [OutlineItem]()
        
        if let rootNode = tree, rootNode.hasChildren {
            for child in rootNode.children {
                filterItems(&result, node: child, withOptions: options)
            }
        }
        
        return result
    }
    
    private func filterItems(_ matchingItems: inout [OutlineItem], node: OutlineItem, withOptions options: TreeFilterOptions) {
        if shouldKeep(node, options: options) {
            matchingItems.append(node)
        }
        
        if node.hasChildren {
            for child in node.children {
                filterItems(&matchingItems, node: child, withOptions: options)
            }
        }
    }
    
    private func shouldKeep(_ node: OutlineItem, options: TreeFilterOptions) -> Bool {
        
        if textFilter(node, options) == false { return false }
        return typeFilter(node, options.typeFilter)
    }
    
    // Age of an item to be included in the filter. The duration we save
    // to the settings is in days, so we need to convert from a number of
    // days to a number of seconds.
    //
    // duration * Mins * Hrs * Days
    private var timeInterval: Double {
        Double(recentDuration) * 60 * 60 * 24
    }
    
    func textFilter(_ node: OutlineItem, _ options: TreeFilterOptions) -> Bool {
        
        if options.hasTextFilter == false { return true }
        
        switch options.searchFields {
        case .titleAndNotes:
            return node.text.localizedCaseInsensitiveContains(options.searchFor)
            || node.notes.localizedCaseInsensitiveContains(options.searchFor)
        case .titleOnly:
            return node.text.localizedCaseInsensitiveContains(options.searchFor)
        case .notesOnly:
            return node.notes.localizedCaseInsensitiveContains(options.searchFor)
        }
    }
    
    func typeFilter(_ node: OutlineItem, _ ofType: DetailViewType) -> Bool {
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
}
