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
    
    public static func clear() {
        NSPasteboard.general.clearContents()
    }
    
    // MARK: OutlinePasteboard functions
    public static func push(_ outlineData: OutlinePasteboard) {
        // We can't copy the struct directlt, we need to wrap it in a class.
        let wrapper = OutlinePasteboardWrapper(content: outlineData)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.writeObjects([wrapper])
    }

    public static func pop() -> OutlinePasteboard? {
        if let item = NSPasteboard.general
            .readObjects(forClasses: [OutlinePasteboardWrapper.self],options: nil)
                as? [OutlinePasteboardWrapper] {
            
            if let outlineData = item.first {
                return outlineData.content
            }
        }
        
        return nil
    }

    // MARK: String functions
    public static func push(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
    
    public static func pop(type: NSPasteboard.PasteboardType = .string) -> String? {
        NSPasteboard.general.string(forType: type)
    }
    
    // MARK: General purpose functions
    public static func contains(type: NSPasteboard.PasteboardType) -> Bool {
        guard let items = NSPasteboard.general.pasteboardItems else { return false }
        return items.filter({ $0.types.contains(type) }).count > 0
    }
}

/// Helper struct that encapsulates the data we want to put on the clipboard
struct OutlinePasteboard: Codable {
    var sourceFile: String
    var contentXML: String
}

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
