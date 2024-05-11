//
// File: OutlinePasteboardWrapper.swift
// Package: Outliner
// Created by: Steven Barnett on 11/05/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import AppKit

/// Defines a wrapper class to use with NSPasteboard, which cannot read and
/// write structs.
class OutlinePasteboardWrapper: NSObject, NSPasteboardWriting, NSPasteboardReading {
    let content: OutlinePasteboard

    init(content: OutlinePasteboard) {
        self.content = content
    }

    // MARK: Conform to NSPasteboardWriting protocol
    static var readableTypesForPasteboard: [NSPasteboard.PasteboardType] { return [.outlinePasteboardType] }

    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.outlinePasteboardType]
    }

    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(content)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Error encoding custom type: \(error)")
            return nil
        }
    }

    // MARK: Conform to NSPasteboardReading protocol
    static func readableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.outlinePasteboardType]
    }

    required init?(pasteboardPropertyList propertyList: Any, ofType type: NSPasteboard.PasteboardType) {
        guard let data = propertyList as? Data else { return nil }
        let decoder = JSONDecoder()
        do {
            let customType = try decoder.decode(OutlinePasteboard.self, from: data)
            self.content = customType
        } catch {
            print("Error decoding custom type: \(error)")
            return nil
        }
    }
}
