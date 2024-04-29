//
// File: FileHelpers.swift
// Package: Mac Template App
// Created by: Steven Barnett on 25/09/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

struct FileHelpers {
    
    // MARK: - File open functopns
    
    /// Select a single file of type 'outline file'.
    ///
    /// - Parameter windowTitle: The title to display in the open file panel.
    ///
    /// - Returns: nil of the user cancels the open else the URL of the selected file.
    public static func selectSingleDataFile(withTitle windowTitle: String?) -> URL? {
        return FileHelpers().selectSingleInputFile(ofType: [.outlineFileType], withTitle: windowTitle)
    }
    
    // MARK: - Save Functions
    
    /// Prompts the user for the name and location to save a file of type 'outline file'.
    ///
    /// - Parameter windowTitle: The title to display in the save panel
    ///
    /// - Returns: nil if the user cancells or the URL of the file to be saved.
    public static func selectOutlineFileToSave(withTitle windowTitle: String?) -> URL? {
        let outlineTypes: [UTType] = [.outlineFileType]
        return FileHelpers().selectSaveFile(ofType: outlineTypes, withTitle: windowTitle)
    }
    
    // MARK: - Folder selection
    
    /// Prompts the user to select a folder.
    ///
    /// - Returns: nil if no folder is selected else the URL of the folder.
    public static func selectFolder() -> URL? {

        let openPrompt = FileHelpers().createOpenPanel(ofType: [], withTitle: nil)

        openPrompt.canChooseDirectories = true
        openPrompt.canChooseFiles = false
        let result = openPrompt.runModal()

        if result == NSApplication.ModalResponse.OK {
            let fName = openPrompt.urls

            guard fName.count == 1 else { return nil }
            return fName[0].absoluteURL
        }

        return nil
    }

    // MARK: - Private helpers
    
    private func selectSingleInputFile(ofType fileTypes: [UTType], withTitle windowTitle: String?) -> URL? {

        let openPrompt = createOpenPanel(ofType: fileTypes, withTitle: windowTitle)

        let result = openPrompt.runModal()

        if result == NSApplication.ModalResponse.OK {
            let fName = openPrompt.urls

            guard fName.count == 1 else { return nil }
            return fName[0].absoluteURL
        }

        return nil
    }
    
    private func createOpenPanel(ofType: [UTType],
                                 withTitle: String?,
                                 allowsMultiple: Bool = false) -> NSOpenPanel {

        let openPrompt = NSOpenPanel()

        if let titlePrompt = withTitle {
            openPrompt.message = titlePrompt
        }

        openPrompt.allowsMultipleSelection = allowsMultiple
        openPrompt.canChooseDirectories = false
        openPrompt.canChooseFiles = true
        openPrompt.resolvesAliases = true
        openPrompt.allowedContentTypes = ofType

        return openPrompt
    }
    
    public func selectSaveFile(ofType fileTypes: [UTType], withTitle windowTitle: String?) -> URL? {

        let openPrompt = createSavePanel(ofType: fileTypes, withTitle: windowTitle)

        let result = openPrompt.runModal()

        if result == NSApplication.ModalResponse.OK {
            let fName = openPrompt.url
            return fName
        }

        return nil
    }

    private func createSavePanel(ofType: [UTType], withTitle: String?) -> NSSavePanel {

        let openPrompt = NSSavePanel()

        if let titlePrompt = withTitle {
            openPrompt.message = titlePrompt
        }

        openPrompt.allowsOtherFileTypes = false
        openPrompt.canCreateDirectories = true
        openPrompt.prompt = "Save As..."
        openPrompt.allowedContentTypes = ofType
        openPrompt.nameFieldLabel = "Enter file name:"
        openPrompt.nameFieldStringValue = "file"

        return openPrompt
    }
}
