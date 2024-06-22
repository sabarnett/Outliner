//
// File: EditCommands.swift
// Package: Outline Tester
// Created by: Steven Barnett on 03/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct EditMenu: Commands {
    
    @FocusedObject private var mainViewModel: MainViewModel?
    
    var hasSelection: Bool {
        guard let mainViewModel,
              mainViewModel.selection != nil
        else { return false }
        
        return true
    }
    
    public var body: some Commands {
        if mainViewModel?.editItem != nil {
            EmptyCommands()
        } else {
            CommandGroup(replacing: .pasteboard) {
                Button("Edit Item") {
                    if let mainViewModel,
                        let selection = mainViewModel.selection {
                        mainViewModel.editNode(selection)
                    }
                }
                .keyboardShortcut("e", modifiers: .command)
                .disabled(!hasSelection)
                
                Divider()
                
                Button("Cut") {
                    mainViewModel?.copyToPasteBoard(cut: true)
                }
                .keyboardShortcut("x", modifiers: .command)
                .disabled(!hasSelection)
                
                Button("Copy") {
                    mainViewModel?.copyToPasteBoard()
                }
                .keyboardShortcut("c", modifiers: .command)
                .disabled(!hasSelection)
                
                Button("Paste") {
                    mainViewModel?.pasteFromPasteboard()
                }
                .keyboardShortcut("v", modifiers: .command)
                .disabled(!hasSelection)
            }
        }
    }
}
