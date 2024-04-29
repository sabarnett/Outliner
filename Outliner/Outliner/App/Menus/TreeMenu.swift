//
// File: FileMenu.swift
// Package: Outline Tester
// Created by: Steven Barnett on 21/12/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

public struct TreeCommands: Commands {
    
    @ObservedObject var outlineManager: OutlineManager
    @FocusedObject private var mainViewModel: MainViewModel?

    @AppStorage(Constants.recentFileCount) var recentFileCount: Int = 5
    
    init(outlineManager: OutlineManager) {
        self.outlineManager = outlineManager
    }
    
    private var hasSelection: Bool {
        mainViewModel?.selection != nil
    }
    
    public var body: some Commands {
        
        CommandMenu("Tree") {
            Button("Expand All") { mainViewModel?.expandSelectedItem() }
            .keyboardShortcut(KeyEquivalent("+"), modifiers: .command)
            .disabled(!hasSelection)
            
            Button("Collapse Children") { mainViewModel?.collapseSelectedItem() }
            .keyboardShortcut(KeyEquivalent("-"), modifiers: .command)
            .disabled(!hasSelection)

            Divider()
            
            Button("Add Item Above") { mainViewModel?.addAbove() }
            .disabled(!hasSelection)

            Button("Add Item Below") { mainViewModel?.addBelow() }
            .disabled(!hasSelection)

            Button("Add Child Item") { mainViewModel?.addChild() }
            .disabled(!hasSelection)

            Button("Duplicate Item") { mainViewModel?.duplicateItem() }
            .disabled(!hasSelection)

            Button("Duplicate Leg") { mainViewModel?.duplicateLeg() }
            .disabled(!hasSelection)

            Divider()
            
            Button("Move Down One Level") { mainViewModel?.indentSelection() }
                .disabled(!(mainViewModel?.canIndent() ?? false))

            Button("Move Up One Level") { mainViewModel?.promoteSelection() }
                .disabled(!(mainViewModel?.canPromote() ?? false))

            Divider()
            
            Button("Delete Item") { mainViewModel?.deleteSelectedItem() }
            .disabled(!hasSelection)

        }
    }
}
