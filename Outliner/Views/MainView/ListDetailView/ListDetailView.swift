//
// File: ListDetailView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 23/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ListDetailView: View {
    
    @AppStorage(Constants.alternatingRows) private var alternatingRows: Bool = true
    @AppStorage(Constants.searchAppliesTo) var searchAppliesTo: SearchAppliesTo = .titleAndNotes

    @ObservedObject var vm: MainViewModel
    var detailViewStyle: DetailViewType
    @State private var listId: UUID = UUID()
    @State private var filterText: String = ""

    var body: some View {
        List(listItems) { item in
            OutlineItemView(node: item)
                .environmentObject(vm)
                .onTapGesture {
                    vm.selection = item
                }
        }
        .alternatingRowBackgrounds(alternatingRows ? .enabled : .disabled)
        .id(listId)
        .onReceive(AppNotifications.refreshOutline) { _ in
            listId = UUID()
        }
        .searchable(text: $filterText, prompt: "Filter results")
    }

    var listItems: [OutlineItem] {
        let searchText = filterText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return vm.outlineItems(detailViewStyle).filter { item in
            if filterText.isEmpty { return true }
            
            if text(of: item, contains: searchText) { return true }
            if note(of: item, contains: searchText) { return true }
            return false
        }
    }

    func text(of item: OutlineItem, contains searchText: String) -> Bool {
        if searchAppliesTo == .notesOnly { return false }
        return item.text.localizedCaseInsensitiveContains(searchText)
    }
    
    func note(of item: OutlineItem, contains searchText: String) -> Bool {
        if searchAppliesTo == .titleOnly { return false }
        return item.notes.localizedCaseInsensitiveContains(searchText)
    }
}

#Preview {
    ListDetailView(vm: MainViewModel(), detailViewStyle: .completed)
}
