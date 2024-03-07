//
// File: Alerts.swift
// Package: Mac Template App
// Created by: Steven Barnett on 19/10/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

// swiftlint:disable identifier_name
enum AlertResponse {
    case yes
    case no
    case delete
    case cancel
    case save
    case discard
}
// swiftlint:enable identifier_name

struct Alerts {
    public static func saveChangesPrompt() -> AlertResponse {
        let captions = ["Save", "Discard"]
        let result = Alerts().openAlert(title: "Save Changes?",
                           message: "You have unsaved changes. Do you want to save your changes of discard them?",
                           buttonTitles: captions)
        
        return (result.rawValue == 1000) ? .save : .discard
    }
    
    public static func fileDoesNotExist(filePath: URL) {
        Alerts().openAlert(
            title: "File Not Found",
            message: "The file you requested does not exist. \n\(filePath.path)."
        )
    }
    
    // MARK: - Load/save the outline file
    
    public static func saveError(message: String) {
        Alerts().openAlert(
            title: "Outline Save Error",
            message: "We were unable to save the outline file. The system reported:\n\n\(message)"
        )
    }
    
    public static func loadError(message: String) {
        Alerts().openAlert(
            title: "Outline Load Error",
            message: "We were unable to read the outline file. The system reported:\n\n\(message)"
        )
    }
    
    // MARK: - Outline Editing
    
    public static func confirmDelete(of itemName: String) -> AlertResponse {
        let captions = ["Delete", "Keep"]
        let result = Alerts().openAlert(title: "Delete Item(s)?",
                           message: "Are you sure you want to delete '\(itemName)' and all of it's child items?",
                           buttonTitles: captions)
        
        return (result.rawValue == 1000) ? .delete : .cancel
    }
    
    // MARK: - Private helper functions

    @discardableResult
    fileprivate func openAlert(title: String, message: String, buttonTitles: [String] = []) -> NSApplication.ModalResponse {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        
        for buttonTitle in buttonTitles {
            if buttonTitle.starts(with: "*") {
                let button = alert.addButton(withTitle: buttonTitle.replacing("*", with: "", maxReplacements: 1))
                button.bezelStyle = .rounded
                button.bezelColor = NSColor.systemRed
            } else {
                
                alert.addButton(withTitle: buttonTitle)
            }
        }
        
        NSApp.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        return response
    }
}
