//
// File: MainViewModel.search.swift
// Package: Outline Tester
// Created by: Steven Barnett on 09/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import SwiftUI
import OutlinerFile

extension MainViewModel {

    // MARK: Search functionality for the List views
    
    func outlineItemsListFilter(withOptions options: TreeFilter.TreeFilterOptions) -> [OutlineItem] {
        let filter = TreeFilter()
        let items = filter.listNodes(fromTree: treeFile, withOptions: options)
        
        if let selection {
            let selectionIndex = items.firstIndex(where: {$0.id == selection.id})
            if selectionIndex == nil {
                self.selection = nil
            }
        }
        
        return items
    }

    // MARK: Search functionality for the OUTLINE view
    
    func performOutlineSearch(searchFor: String, lookingIn appliesTo: SearchAppliesTo) {
        if searchFor.isEmpty {
            searchResults = nil
            searchIndex = 0
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let searchOptions = TreeFilter.TreeFilterOptions(
                searchFor: searchFor,
                searchFields: appliesTo,
                typeFilter: .outline
                )
            
            let search = TreeFilter()
            let result = search.listNodes(fromTree: self.treeFile, withOptions: searchOptions)
            
            DispatchQueue.main.async {
                self.searchResults = result
                self.searchIndex = 0
                if result.count > 0 {
                    self.selectAndMakeVisible(item: result[0])
                }
            }
        }
    }
    
    var canSearchPrevious: Bool {
        guard let searchResults else { return false }
        return searchResults.count > 0 && searchIndex != 0
    }
    
    var canSearchNext: Bool {
        guard let searchResults else { return false }
        return searchResults.count > 0 && searchIndex != (searchResults.count - 1)
    }
    
    var searchResultCount: Int {
        guard let searchResults else { return 0 }
        return searchResults.count
    }
    
    func searchMovePrevious() {
        guard let searchResults,
                    searchIndex > 0
        else { return }
        searchIndex -= 1
        selectAndMakeVisible(item: searchResults[searchIndex])
    }
    
    func searchMoveNext() {
        guard let searchResults,
              searchIndex <= searchResults.count
        else { return }
        searchIndex += 1
        selectAndMakeVisible(item: searchResults[searchIndex])
    }

    func selectAndMakeVisible(item: OutlineItem) {
        // loop up the parent tree, ensuring the parent is expanded
        var current = item
        while current.parent != nil {
            guard let parent = current.parent else { break }
            if parent.isExpanded { break }
            parent.isExpanded = true
            current = parent
        }
        
        self.selection = item
        
        // This will cause the selected node to scroll into view.
        self.scrollTo = item.id
    }
}
