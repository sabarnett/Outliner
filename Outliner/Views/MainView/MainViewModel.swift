//
// File: MainViewModel.swift
// Package: Mac Template App
// Created by: Steven Barnett on 07/09/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation

class MainViewModel: ObservableObject, Identifiable {
    var id: UUID = UUID()
    var treeFile: OpmlFile
    var outlineFileUrl: URL
    var requiresSave: Bool { tree?.hasDataChanged() ?? false }
    
    var lastSortedItem: OutlineItem?
    var lastSortBy: OutlineItemSort?
    var sortAscending: Bool = false

    @Published var tree: OutlineItem?
    @Published var isLoading: Bool = true
    @Published var windowTitle: String = "unnamed file"
    @Published var selection: OutlineItem?
    @Published var viewNote: NodeViewViewModel?
    @Published var editItem: NodeEditViewModel?
    
    @Published var nodeCount: Int = 0
    @Published var starredCount: Int = 0
    @Published var completeCount: Int = 0
    @Published var incompleteCount: Int = 0
    
    @Published var searchResults: [OutlineItem]?
    @Published var searchIndex: Int = 0
    
    // MARK: - Initialisation
    
    init() {
        treeFile = OpmlFile()
        outlineFileUrl = URL(string: "newFile")!
    }
    
    func load(outline: URL?) {
        guard let outline = outline else {
            tree = treeFile.outline.outlineBody!
            windowTitle = treeFile.fileNameWithExtension

            isLoading = false
            return
        }
        
        outlineFileUrl = outline
        treeFile = OpmlFile(fromUrl: outline)
        
        if let root = treeFile.outline.outlineBody {
            root.visible = true
            if root.hasChildren {
                for child in root.children {
                    child.visible = true
                }
            }
        }
        
        tree = treeFile.outline.outlineBody!
        windowTitle = treeFile.fileNameWithExtension
        calculateStatistics()
        
        self.isLoading = false
    }

    func calculateStatistics() {
        DispatchQueue.global(qos: .userInitiated).async {
            var calc = TreeStats()
            calc.calculate(forTree: self.tree)

            DispatchQueue.main.async {
                self.nodeCount = calc.nodeCount
                self.starredCount = calc.starredCount
                self.completeCount = calc.completeCount
                self.incompleteCount = calc.incompleteCount
            }
        }
    }
    
    // MARK: - Cleanup
    
    func reset() {
        // Any last minute cleanup
    }
    
    // MARK: - Save/save-as
    
    @discardableResult
    func save() -> String? {
        if outlineFileUrl.path != "newFile" {
            treeFile.saveOutline()
            return outlineFileUrl.path
        } else {
            // No file name, so call save-as
            _ = saveas()
            return outlineFileUrl.path
        }
    }
    
    /// Save the file using a new URL. Prompt the user for the file name and, if they select
    /// a file, save to that file.
    ///
    /// - Returns: Returns the URL of the saved file or nil if the file was not saved.
    func saveas() -> (oldFilePath: String, newFilePath: String?) {
        let oldFile = outlineFileUrl

        if let saveFile = FileHelpers.selectOutlineFileToSave(withTitle: "Save outline to...") {
            outlineFileUrl = saveFile
            treeFile.saveOutline(to: saveFile)
            windowTitle = treeFile.fileNameWithExtension
            
            return (oldFilePath: oldFile.path, newFilePath: saveFile.path)
        }
        
        return (oldFilePath: oldFile.path, newFilePath: nil)
    }
}

extension MainViewModel {
    
    // MARK: - view/edit node
    
    func showNote(_ node: OutlineItem) {
        viewNote = NodeViewViewModel(node: node)
    }
    
    func editNode(_ node: OutlineItem) {
        editItem = NodeEditViewModel(node: node, editActtion: .editExisting, onSave: editComplete)
    }
    
    func editComplete(node: OutlineItem, editAction: EditAction) {
        if editAction != .editExisting {
            // save the node to the hierarchy.
            self.selection = selection?.addNewNode(node: node, relativePosition: editAction.insertionPoint!)
        }
        calculateStatistics()
    }
}

// MARK: - Handlers for the menus we added.

extension MainViewModel {

    // MARK: - Tree function handlers
    
    func expandSelectedItem() {
        if let selection {
            selection.setExpansionState(to: .expanded)
        }
    }

    func collapseSelectedItem() {
        if let selection {
            selection.setExpansionState(to: .collapsed)
        }
    }
    
    func addAbove() {
        let newNode = OutlineItem()
        newNode.text = "New Node Above"
        newNode.notes = "Inserted Node \(Date.now.description)"
        
        editItem = NodeEditViewModel(node: newNode, editActtion: .addAbove, onSave: editComplete)
    }
    
    func addBelow() {
        let newNode = OutlineItem()
        newNode.text = "New Node Below"
        newNode.notes = "Inserted Node \(Date.now.description)"
        
        editItem = NodeEditViewModel(node: newNode, editActtion: .addBelow, onSave: editComplete)
    }
    
    func addChild() {
        let newNode = OutlineItem()
        newNode.text = "New Node Child"
        newNode.notes = "Inserted Node \(Date.now.description)"
        
        editItem = NodeEditViewModel(node: newNode, editActtion: .addChild, onSave: editComplete)
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
        if let leg = treeFile.itemsFromXML(xml: xml) {
            leg.parent = parent
            parent.children.insert(leg, at: selectionIndex + 1)
            self.selection = leg
        } else {
            print("Nothing found")
        }
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
