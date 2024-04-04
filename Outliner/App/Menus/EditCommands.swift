//
// File: EditCommands.swift
// Package: Outline Tester
// Created by: Steven Barnett on 03/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct EditCommands: Commands {
    
    @FocusedObject private var mainViewModel: MainViewModel?
    
    public var body: some Commands {
        CommandGroup(replacing: .pasteboard) {
            Button("Cut") {
                mainViewModel?.copyToPasteBoard(cut: true)
            }
            .keyboardShortcut("x", modifiers: .command)
            
            Button("Copy") {
                mainViewModel?.copyToPasteBoard()
            }
            .keyboardShortcut("c", modifiers: .command)
            
            Button("Paste") {
                mainViewModel?.pasteFromPasteboard()
            }
            .keyboardShortcut("v", modifiers: .command)
        }
    }
}
