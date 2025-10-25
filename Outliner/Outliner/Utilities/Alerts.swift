//
// File: Alerts.swift
// Package: Mac Template App
// Created by: Steven Barnett on 19/10/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerViews

extension Alerts {
    /// Ask the user whether they want to save the file. This is called when a file is closed
    /// while there are outstanding changes. The user gets to sve the file or discard the
    /// unsaved changes.
    ///
    /// - Returns: .save if the user wants to save or .discard
    public static func saveChangesPrompt() -> AlertResponseSaveDiscard {
        let captions = ["Save", "*Discard"]
        let result = Alerts().openAlert(title: "Save Changes?",
                           message: "You have unsaved changes. Do you want to save your changes of discard them?",
                           buttonTitles: captions)
        
        return (result.rawValue == 1000) ? .save : .discard
    }
    
    /// Displays a message to the user that the file they have tried to access no longer
    /// exists. The path to the file will be included in the message.
    ///
    /// - Parameter filePath: The full URL to the missing file.
    public static func fileDoesNotExist(filePath: URL) {
        Alerts().openAlert(
            title: "File Not Found",
            message: "The file you requested does not exist. \n\(filePath.path)."
        )
    }
    
    // MARK: - Load/save the outline file
    
    /// Displayed when we were unable to save the file. The reason for the error is
    /// included in the message.
    ///
    /// - Parameter message: The failure reason
    public static func saveError(message: String) {
        Alerts().openAlert(
            title: "Outline Save Error",
            message: "We were unable to save the outline file. The system reported:\n\n\(message)"
        )
    }
    
    /// Displayed when open a file causes a load error. Something went wrong, the file was
    /// empty, we do not have permissions, the filehas an invalid format etc... The reason for
    /// the load failure is included in the message.
    ///
    /// - Parameter message: The reason for the failure.
    public static func loadError(message: String) {
        Alerts().openAlert(
            title: "Outline Load Error",
            message: "We were unable to read the outline file. The system reported:\n\n\(message)"
        )
    }
    
    // MARK: - Outline Editing
    
    /// Prompt the user to confirm that they want to delete an item along with all of
    /// it's child nodes. The user must confirm the delete as this is a drastic action.
    ///
    /// - Parameter itemName: The currently selected item title.
    ///
    /// - Returns: .delete or .cancel depending on which buton the user clicks.
    public static func confirmDelete(of itemName: String) -> AlertResponseDeleteCancel {
        let captions = ["*Delete", "Keep"]
        let result = Alerts().openAlert(title: "Delete Item(s)?",
                           message: "Are you sure you want to delete '\(itemName)' and all of it's child items?",
                           buttonTitles: captions)
        
        return (result.rawValue == 1000) ? .delete : .cancel
    }
    
    // MARK: - Drag and drop move errors.
    
    /// Displays a message to the user when they use drag and drop to move an item and
    /// they drop the item on itself. This is not allowed.
    public static func cannotMoveToYourself() {
        Alerts().openAlert(
            title: "Move Failed",
            message: "You cannot move an item to itself."
        )
    }
    
    /// Displays a message to the user when they use drag and drop to move an item and
    /// they drop the item somewhere down the same hierarchy leg. This cannot be done.
    public static func cannotMoveToDecendent() {
        Alerts().openAlert(
            title: "Move Failed",
            message: "You cannot move an item to a position below itself."
        )
    }
    
    // MARK: - Export messages
    
    /// Displayed when we were unable to export to a file. The reason for the error is
    /// included in the message.
    ///
    /// - Parameter message: The failure reason
    public static func exportError(message: String) {
        Alerts().openAlert(
            title: "Export Error",
            message: "We were unable to export the outline. The system reported:\n\n\(message)"
        )
    }
}
