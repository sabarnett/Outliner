//
// File: MainViewModel.structure.swift
// Package: Outline Tester
// Created by: Steven Barnett on 09/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import Foundation
import OutlinerViews
import OutlinerFile

extension MainViewModel {
    
    func expandSelectedItem() {
        guard let selection else { return }
        selection.setExpansionState(to: .expanded)
    }

    func collapseSelectedItem() {
        guard let selection else { return }
        selection.setExpansionState(to: .collapsed)
    }
    
    func addAbove() {
        let newNode = newOutlineItem()
        editItem = NodeEditViewModel(node: newNode, editActtion: .addAbove, onSave: editComplete)
    }
    
    func addBelow() {
        let newNode = newOutlineItem()
        editItem = NodeEditViewModel(node: newNode, editActtion: .addBelow, onSave: editComplete)
    }
    
    func addChild() {
        let newNode = newOutlineItem()
        editItem = NodeEditViewModel(node: newNode, editActtion: .addChild, onSave: editComplete)
    }
    
    private func newOutlineItem() -> OutlineItem {
        let newNode = OutlineItem()
        newNode.text = "New Item"
        newNode.notes = "Inserted \(Date.now.description)"
        return newNode
    }
    
    func duplicateItem() {
        guard let selection,
              let parent = selection.parent,
              let selectionIndex = parent.children.firstIndex(where: { $0.id == selection.id })
        else { return }
        
        let newItem = OutlineItem(from: selection)

        objectWillChange.send()
        parent.children.insert(newItem, at: selectionIndex + 1)
        self.selection = newItem
        
        calculateStatistics()
    }
    
    func duplicateLeg() {
        guard let selection,
              let parent = selection.parent,
              let selectionIndex = parent.children.firstIndex(where: {$0.id == selection.id })
        else { return }
        
        // Convert the hierarchy leg to an OpmlFile XML string
        let xml = treeFile.outlineXML(forRoot: selection)

        // Convert the xml back to a hierarchy of OutlineItems
        if let leg = try? treeFile.itemsFromXML(xml: xml) {
            leg.parent = parent
            parent.children.insert(leg, at: selectionIndex + 1)
            self.selection = leg
        } else {
            print("Nothing found")
        }
        calculateStatistics()
    }
    
    func deleteSelectedItem() {
        if let selection = selection,
           Alerts.confirmDelete(of: selection.text) == .delete {
            self.objectWillChange.send()
            self.selection = selection.delete()
        }
        calculateStatistics()
    }
    
    func sortLevel(by sortBy: OutlineItemSort) {
        guard let selection,
              let parent = selection.parent
        else { return }
        
        if let lastSortedItem,
                lastSortedItem == parent,
                lastSortBy == sortBy {
                sortAscending = !sortAscending
        } else {
            sortAscending = true
        }
        
        do {
            try parent.children.sort(by: sortBy.sortComparator)
            if !sortAscending {
                parent.children.reverse()
            }

            lastSortedItem = parent
            lastSortBy = sortBy
            parent.hasChanged = true
        } catch {
            print("Sort failed: \(error.localizedDescription)")
        }
    }

    @MainActor
    func move(_ source: OutlineItem, to targetNode: OutlineItem, inserting: NodeMoveRelativePosition) {
        let mover = NodeMover()
        mover.move(source, to: targetNode, inserting: inserting, inTree: self.tree!)
        
        DispatchQueue.main.async {
            if inserting == .child {
                targetNode.setExpansionState(to: .expanded)
            }
            
            self.objectWillChange.send()
        }
    }
    
    /// We can only indent if we are not the first child in our parent.
    func canIndent(item: OutlineItem? = nil) -> Bool {
        let testItem = item ?? selection
        guard let testItem,
              let parent = testItem.parent else { return false }
        
        let selectionIndex = parent.children.firstIndex(where: {$0.id == testItem.id}) ?? 0
        return selectionIndex > 0
    }
    
    @MainActor func indentSelection() {
        guard let selection,
              let parent = selection.parent,
              let selectionIndex = parent.children.firstIndex(where: {$0.id == selection.id})
        else { return }
        
        let target = parent.children[selectionIndex-1]
        move(selection, to: target, inserting: .child)
    }
    
    /// We can only promote if we are not at the top most level
    func canPromote(item: OutlineItem? = nil) -> Bool {
        let testItem = item ?? selection
        guard let testItem,
              let tree,
              let parent = testItem.parent else { return false }
        
        return parent.id != tree.id
    }
    
    @MainActor func promoteSelection() {
        guard let selection,
              let parent = selection.parent else { return }

        move(selection, to: parent, inserting: .below)
    }
}

enum EditAction {
    case addAbove
    case addBelow
    case addChild
    case editExisting
    
    var insertionPoint: NodeInsertionPoint? {
        switch self {
        case .addAbove:
            return .above
        case .addBelow:
            return .below
        case .addChild:
            return .child
        case .editExisting:
            return nil
        }
    }
}
