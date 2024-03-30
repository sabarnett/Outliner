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
    var requiresSave: Bool { tree?.dataHasChanged() ?? false }

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

    func outlineItems(_ ofType: DetailViewType) -> [OutlineItem] {
        // Walk the tree.
        let filter = TreeFilter()
        return filter.listNodes(ofType: ofType, fromTree: tree)
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
    
    @MainActor
    func move(_ source: OutlineItem, to targetNode: OutlineItem, inserting: NodeMoveRelativeTo) {
        let mover = NodeMover()
        mover.move(source, to: targetNode, inserting: inserting, inTree: self.tree!)
        
        DispatchQueue.main.async {
            if inserting == .child {
                targetNode.setExpansionState(to: .expanded)
            }
            
            self.objectWillChange.send()
        }
    }
    
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

extension MainViewModel {
    
    // MARK: - Pasteboard handlers
    
    func copyToPasteBoard() {
//        PasteBoard.push(selectedItem)
    }
    
    func clearPasteBoard() {
        PasteBoard.clear()
    }

    func getFromPasteBoard() -> String {
        PasteBoard.pop() ?? ""
    }
    
    func hasTextValue() -> Bool {
        PasteBoard.contains(type: .string)
    }
}

// Handlers for the menus we added.
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
            self.selection = selection.delete()
            self.objectWillChange.send()
        }
        calculateStatistics()
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
