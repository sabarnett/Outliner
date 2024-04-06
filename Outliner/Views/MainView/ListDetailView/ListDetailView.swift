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
    @ObservedObject var vm: MainViewModel
    var detailViewStyle: DetailViewType
    @State private var listId: UUID = UUID()
    @State private var filterText: String = ""
    
    var listItems: [OutlineItem] {
        vm.outlineItems(detailViewStyle).filter { item in
            if filterText.isEmpty { return true }
            
            if item.text.range(of: filterText, options: .caseInsensitive) != nil {
                return true
            }
            
            if item.notes.range(of: filterText, options: .caseInsensitive) != nil {
                return true
            }
            
            return false
        }
        
    }

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
}

#Preview {
    ListDetailView(vm: MainViewModel(), detailViewStyle: .completed)
}
