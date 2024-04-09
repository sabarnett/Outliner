//
// File: MainViewModel.search.swift
// Package: Outline Tester
// Created by: Steven Barnett on 09/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import SwiftUI

extension MainViewModel {

    // MARK: Search functionality for the List views
    
    func outlineItemsListFilter(withOptions options: TreeFilterOptions) -> [OutlineItem] {
        let filter = TreeFilter()
        return filter.listNodes(fromTree: tree, withOptions: options)
    }

    // MARK: Search functionality for the OUTLINE view
    
    func performOutlineSearch(searchFor: String, lookingIn appliesTo: SearchAppliesTo) {
        if searchFor.isEmpty {
            searchResults = nil
            searchIndex = 0
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let searchOptions = TreeFilterOptions(
                searchFor: searchFor,
                searchFields: appliesTo,
                typeFilter: .outline
                )
            
            let search = TreeFilter()
            let result = search.listNodes(fromTree: self.tree, withOptions: searchOptions)
            
            DispatchQueue.main.async {
                self.searchResults = result
                self.searchIndex = 0
                if result.count > 0 {
                    self.selection = result[0]
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
        selection = searchResults[searchIndex]
    }
    
    func searchMoveNext() {
        guard let searchResults,
              searchIndex <= searchResults.count
        else { return }
        searchIndex += 1
        selection = searchResults[searchIndex]
    }

}
