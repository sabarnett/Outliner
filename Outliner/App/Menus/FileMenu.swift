//
// File: FileMenu.swift
// Package: Outline Tester
// Created by: Steven Barnett on 21/12/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

public struct FileCommands: Commands {
    
    @ObservedObject var outlineManager: OutlineManager
    @FocusedObject private var mainViewModel: MainViewModel?

    @AppStorage(Constants.recentFileCount) var recentFileCount = 5
    
    var requiresSave: Bool {
        if let mainViewModel {
            return mainViewModel.requiresSave
        }
        return false
    }
    
    public var body: some Commands {
        
        CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button("New Outline") {
                outlineManager.createNew()
            }
            Divider()
        }

        CommandGroup(after: CommandGroupPlacement.newItem) {
            Button("Open Outline...") {
                if let selectedFile = FileHelpers.selectSingleDataFile(withTitle: "Select an outline file") {
                    outlineManager.openFile(at: selectedFile)
                }
            }
            
            if outlineManager.recentFiles.count > 0 {
                Menu("Reopen Outline") {
                    ForEach(outlineManager.recentFiles.prefix(recentFileCount)) { file in
                        Button(file.fileName) {
                            outlineManager.openFile(at: file.fileURL)
                        }.help(file.fileURL.path)
                    }
                    Divider()
                    Button("Clear Recent Files List") {
                        outlineManager.clearHistory()
                    }
                }
            }
            Divider()

            Button("Save Outline") {
                if let savedFilePath = mainViewModel?.save() {
                    outlineManager.saved(file: savedFilePath)
                }
            }.keyboardShortcut(KeyEquivalent("s"), modifiers: .command)
                .disabled(!requiresSave)
            
            Button("Save Outline As...") {
                guard let files = mainViewModel?.saveas() else { return }
                if let newFile = files.newFilePath {
                    outlineManager.saved(file: files.oldFilePath, as: newFile)
                }
            }.keyboardShortcut(KeyEquivalent("a"), modifiers: .command)
                .disabled(mainViewModel == nil)
        }
    }
}
