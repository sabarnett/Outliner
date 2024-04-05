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
    
    public var body: some Commands {
        CommandGroup(replacing: .pasteboard) {
            Button("Cut") {
                mainViewModel?.copyToPasteBoard(cut: true)
            }
            .keyboardShortcut("x", modifiers: .command)
            .disabled(mainViewModel?.selection == nil)
            
            Button("Copy") {
                mainViewModel?.copyToPasteBoard()
            }
            .keyboardShortcut("c", modifiers: .command)
            .disabled(mainViewModel?.selection == nil)

            Button("Paste") {
                mainViewModel?.pasteFromPasteboard()
            }
            .keyboardShortcut("v", modifiers: .command)
            .disabled(!(mainViewModel?.hasOutlineValue() ?? true))
        }
    }
}
