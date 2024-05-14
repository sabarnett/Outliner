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
            calculateStatistics()
        }
        
        notify.showPopup(.success,
                         title: "Copied",
                         description: "Copied to the pasteboard")
    }

    func pasteFromPasteboard() {
        guard let pasteData: OutlinePasteboard = PasteBoard.pop() else { return }
        guard let selection,
              let parent = selection.parent,
              let selectionIndex = parent.children.firstIndex(where: {$0.id == selection.id })
        else { return }
        
        // Convert the xml back to a hierarchy of OutlineItems
        if let leg = try? treeFile.itemsFromXML(xml: pasteData.contentXML) {
            leg.parent = parent
            parent.children.insert(leg, at: selectionIndex + 1)
            parent.hasChanged = true
            self.selection = leg
            calculateStatistics()

            notify.showPopup(.success,
                             title: "Paste Complete",
                             description: "Paste from pasteboard")

        } else {
            
            notify.showPopup(.failure,
                             title: "Nothing To Paste",
                             description: "Nothing on the pasteboard")
        }
    }
    
    func hasOutlineValue() -> Bool {
        PasteBoard.contains(type: .outlinePasteboardType)
    }
    
    func clearPasteBoard() {
        PasteBoard.clear()
    }
}
