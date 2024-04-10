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
    
    var notify = PopupNotificationCentre.shared

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
    @Published var searchFor: String = ""
    
    @Published var listId: UUID = UUID()
    @Published var scrollTo: UUID?
    
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
        viewNote = NodeViewViewModel(node: node, highlightText: searchFor)
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
