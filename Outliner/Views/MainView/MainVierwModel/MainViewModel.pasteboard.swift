//
// File: MainViewModel.pasteboard.swift
// Package: Outline Tester
// Created by: Steven Barnett on 09/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import Foundation

extension MainViewModel {
    
    // MARK: - Pasteboard handlers
    
    func copyToPasteBoard(cut: Bool = false) {
        // If we 'cut' we also need to delete the leg.
        guard let selection else { return }
        
        let xml = treeFile.outlineXML(forRoot: selection)
        let fileName = outlineFileUrl.path(percentEncoded: false)
        let clipboardContent = OutlinePasteboard(
            sourceFile: fileName,
            contentXML: xml
        )
        
        PasteBoard.push(clipboardContent)
        
        if cut {
            self.objectWillChange.send()
            self.selection = selection.delete()
        }
        
        notify.showPopup(.success,
                         title: "Copied to Pasteboard",
                         description: "Copied to the pasteboard")
    }

    func pasteFromPasteboard() {
        guard let pasteData = PasteBoard.pop() else { return }
        guard let selection,
              let parent = selection.parent,
              let selectionIndex = parent.children.firstIndex(where: {$0.id == selection.id })
        else { return }
        
        // Convert the xml back to a hierarchy of OutlineItems
        if let leg = treeFile.itemsFromXML(xml: pasteData.contentXML) {
            leg.parent = parent
            parent.children.insert(leg, at: selectionIndex + 1)
            parent.hasChanged = true
            self.selection = leg

            notify.showPopup(.success,
                             title: "Paste From Pasteboard",
                             description: "Paste from pasteboard")

        } else {
            
            notify.showPopup(.failure,
                             title: "Nothing To Paste",
                             description: "Nothing on the pasteboard")
        }
    }
    
    func hasOutlineValue() -> Bool {
        if PasteBoard.contains(type: .outlinePasteboardType) {
            return true
        }
        return false
    }
    
    func clearPasteBoard() {
        PasteBoard.clear()
    }
}
