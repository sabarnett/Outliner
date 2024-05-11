//
// File: TreeFilter.swift
// Package: Outline Tester
// Created by: Steven Barnett on 24/01/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerFile

public struct TreeFilter {
    public struct TreeFilterOptions {
        var searchFor: String = ""
        var searchFields: SearchAppliesTo = .titleAndNotes
        var typeFilter: DetailViewType = .outline
        
        var hasTextFilter: Bool { !searchFor.isEmpty }
    }
    
    @AppStorage(Constants.durationForRecentFilters) var recentDuration: Int = 5
    
    public func listNodes(fromTree tree: OpmlFile, withOptions options: TreeFilterOptions) -> [OutlineItem] {
        
        var result = [OutlineItem]()
        
        for item in tree where shouldKeep(item, options: options) {
            result.append(item)
        }
        return result
    }

    fileprivate func shouldKeep(_ node: OutlineItem, options: TreeFilterOptions) -> Bool {
        
        if textFilter(node, options) == false { return false }
        return typeFilter(node, options.typeFilter)
    }
    
    // Age of an item to be included in the filter. The duration we save
    // to the settings is in days, so we need to convert from a number of
    // days to a number of seconds.
    //
    // duration * Mins * Hrs * Days
    fileprivate var timeInterval: Double {
        Double(recentDuration) * 60 * 60 * 24
    }
    
    fileprivate func textFilter(_ node: OutlineItem, _ options: TreeFilterOptions) -> Bool {
        
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
    
    fileprivate func typeFilter(_ node: OutlineItem, _ ofType: DetailViewType) -> Bool {
        switch ofType {
        case .outline:
            return true
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
