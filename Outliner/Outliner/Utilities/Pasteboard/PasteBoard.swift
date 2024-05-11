//
// File: PasteBoard.swift
// Package: Mac Template App
// Created by: Steven Barnett on 14/10/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import AppKit

// We want to be able to identify our data on the pasteboard, so extend
// PasteboardType to include our own type name
extension NSPasteboard.PasteboardType {
    static let outlinePasteboardType = NSPasteboard.PasteboardType(rawValue: Constants.outlinePasteboardType)
}

struct PasteBoard {
    
    /// Clear the pasteboard
    public static func clear() {
        NSPasteboard.general.clearContents()
    }
    
    // MARK: OutlinePasteboard functions
    
    /// Put an out;line item onto the pasteboard.
    ///
    /// - Parameter outlineData: The outline data to push onto the pasteboard
    ///
    /// The data we want to push is held in an OutlinePasteboard struct. However, the
    /// pasteboard does not support pushing structs, so we wrap the data in a
    /// ``OutlinePasteboardWrapper`` class instance.
    ///
    public static func push(_ outlineData: OutlinePasteboard) {
        let wrapper = OutlinePasteboardWrapper(content: outlineData)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([wrapper])
    }
    
    /// Checks the pasteboard to see if we have an ``OutlinePasteboardWrapper`` instance
    /// and returns the wrapped ``OutlinePasteboard`` if it is found. If there is no wrapper
    /// on the pasteboard, we return nil.
    ///
    /// - Returns: An instance of the OutlinePasteboard struct if there is data on the
    /// pasteoard or nil if there is no outline data on the pasteboard.
    ///
    public static func pop() -> OutlinePasteboard? {
        if let item = NSPasteboard.general
            .readObjects(forClasses: [OutlinePasteboardWrapper.self], options: nil)
                as? [OutlinePasteboardWrapper] {
            
            if let outlineData = item.first {
                return outlineData.content
            }
        }
        
        return nil
    }

    // MARK: String functions
    
    /// Pushes a string onto the pasteboard
    ///
    /// - Parameter text: The text string to push
    public static func push(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
    
    /// Pops a string from the pasteboard
    ///
    /// - Returns: The string from the pasteboard or nil if there is no text to paste.
    public static func pop() -> String? {
        NSPasteboard.general.string(forType: .string)
    }
    
    // MARK: General purpose functions
    
    public static func contains(type: NSPasteboard.PasteboardType) -> Bool {
        guard let items = NSPasteboard.general.pasteboardItems else { return false }
        return items.filter({ $0.types.contains(type) }).count > 0
    }
}
