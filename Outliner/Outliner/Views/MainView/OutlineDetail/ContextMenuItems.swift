//
// File: ContextMenuItems.swift
// Package: Outline Tester
// Created by: Steven Barnett on 30/03/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerFile

struct ContextMenuItems: View {
    
    @EnvironmentObject var vm: MainViewModel
    
    var node: OutlineItem
    
    var body: some View {
        Group {
            Text(node.text).font(.title)
            Text("Children: \(node.count)").font(.title2)
            Divider()
            
            editMenu()
            structureMenu()
            sortMenu()
            
            deleteMenu()
            
            printAndExportMenu()
        }
    }
    
    @ViewBuilder
    private func editMenu() -> some View {
        Menu(content: {
            Button("Edit Item") {
                vm.editNode(vm.selection!)
            }
            .disabled(vm.selection == nil)
            
            Divider()
            
            Button("Cut") {
                vm.copyToPasteBoard(cut: true)
            }
            Button("Copy") {
                vm.copyToPasteBoard()
            }
            Button("Paste") {
                vm.pasteFromPasteboard()
            }
            .disabled(!vm.hasOutlineValue())
        },
             label: {
            Text("Edit")
        })
    }
    
    @ViewBuilder
    private func structureMenu() -> some View {
        Menu(content: {
            Button("Add Item Above") {
                vm.selection = node
                vm.addAbove()
            }
            
            Button("Add Item Below") {
                vm.selection = node
                vm.addBelow()
            }
            
            Button("Add Child Item") {
                vm.selection = node
                vm.addChild()
            }
        }, label: { Text("Insert") })
        
        Menu(content: {
            Button("Current Item") {
                vm.selection = node
                vm.duplicateItem()
            }
            
            Button("Current Item And Children") {
                vm.selection = node
                vm.duplicateLeg()
            }
        }, label: { Text("Duplicate")})

        Menu(content: {
            Button("Move Item Down One Level") {
                vm.selection = node
                vm.indentSelection() }
            .disabled(!(vm.canIndent(item: node)))
            
            Button("Move Item Up One Level") {
                vm.selection = node
                vm.promoteSelection() }
            .disabled(!(vm.canPromote(item: node)))
        }, label: { Text("Move")})
        
        Divider()
    }

    @ViewBuilder
    private func sortMenu() -> some View {
        Menu(content: {
            ForEach(OutlineItemSort.allCases) { sortBy in
                Button(sortBy.description) {
                    vm.selection = node
                    vm.sortLevel(by: sortBy)
                }
            }
        }, label: { Text("Sort Level")})
        
        Divider()
    }

    @ViewBuilder
    private func deleteMenu() -> some View {
        Button("Delete Item") {
            vm.selection = node
            vm.deleteSelectedItem()
        }
        
        Divider()
    }
    
    @ViewBuilder
    private func printAndExportMenu() -> some View {
        Menu(content: {
            Button("Print current item") {
                vm.selection = node
                vm.printSelected() }
            
            Button("Print item and children") {
                vm.selection = node
                vm.printSelectedLeg() }
        }, label: { Text("Print")})

        Button("Export") {
            vm.showexport = true
        }
    }
}

#Preview {
    Menu("Menu", content: {
        ContextMenuItems(node: OutlineItem.example)
            .environmentObject(MainViewModel())
    })
}

enum OutlineItemSort: String, CaseIterable, Identifiable, CustomStringConvertible {
    case byName
    case byStarred
    case byCreationDate
    case byUpdatedDate
    case byCompletionDate
    
    var id: String { return self.description }
    
    var description: String {
        switch self {
        case .byName:
            return "By Name"
        case .byStarred:
            return "By Starred"
        case .byCreationDate:
            return "By Creation Date"
        case .byUpdatedDate:
            return "By Updated Date"
        case .byCompletionDate:
            return "By Completed Date"
        }
    }
    
    var sortComparator: ((OutlineItem, OutlineItem) throws -> Bool) {
        switch self {
        case .byName:
            // Sort by name, ifnoring case
            return { lhs, rhs in
                lhs.text.localizedCaseInsensitiveCompare(rhs.text) == .orderedAscending
            }
        case .byStarred:
            // Sort by starred status. If both are starred or unstarred, then
            // sort by name.
            return { lhs, rhs in
                if lhs.starred == rhs.starred {
                    return lhs.text.localizedCaseInsensitiveCompare(rhs.text) == .orderedAscending
                }
                return lhs.starred
            }
        case .byCreationDate:
            // Sort by creation date. If both were created at the same
            // date and time, then sort by name
            return { lhs, rhs in
                let left = lhs.createdDate ?? Date.distantPast
                let right = rhs.createdDate ?? Date.distantPast
                
                if left == right {
                    return lhs.text.localizedCaseInsensitiveCompare(rhs.text) == .orderedAscending
                }
                return left > right
            }
        case .byUpdatedDate:
            // Sort by last updated date. If both were updated at the same
            // date and time, then sort by name
            return { lhs, rhs in
                let left = lhs.updatedDate ?? Date.distantPast
                let right = rhs.updatedDate ?? Date.distantPast
                
                if left == right {
                    return lhs.text.localizedCaseInsensitiveCompare(rhs.text) == .orderedAscending
                }
                return left > right
            }
        case .byCompletionDate:
            // Sort by completed date. If both were completed at the same
            // date and time, then sort by name
            return { lhs, rhs in
                let left = lhs.completedDate ?? Date.distantPast
                let right = rhs.completedDate ?? Date.distantPast
                
                if left == right {
                    return lhs.text.localizedCaseInsensitiveCompare(rhs.text) == .orderedAscending
                }
                return left > right
            }
        }
    }
}
