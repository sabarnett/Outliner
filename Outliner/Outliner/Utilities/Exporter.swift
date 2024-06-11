//
// File: Exporter.swift
// Package: Outliner
// Created by: Steven Barnett on 07/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import OutlinerFile
import OutlinerViews
import MarkdownKit
import SwiftUI

struct Exporter {

    @AppStorage(Constants.exportOpenInFinder) private var openInFinder: Bool = true
    @AppStorage(Constants.exportOpenFile) private var openFile: Bool = false
    @AppStorage(Constants.printIncludeTitle) private var includeTitle: Bool = true
    @AppStorage(Constants.printIncludeSeparator) private var includeSeparator: Bool = true
    
    var notify = PopupNotificationCentre.shared

    public func export(
        treeFile: OpmlFile,
        selection: OutlineItem,
        exportFormat: ExportFormat,
        exportContent: ExportContent
    ) {
        switch (exportFormat, exportContent) {
        case (.html, .single):
            exportSingleToHtml(item: selection)
        case (.html, .leg):
            exportLegToHtml(item: selection)
            
        case (.xml, .single):
            exportSingleToXml(treeFile: treeFile, item: selection)
        case (.xml, .leg):
            exportLegToXml(treeFile: treeFile, item: selection)
            
        case (.json, .single):
            exportSingleToJson(treeFile: treeFile, item: selection)
        case (.json, .leg):
            exportLegToJson(treeFile: treeFile, item: selection)

        }
    }
    
    // MARK: - Export to HTML
    
    private func exportSingleToHtml(item: OutlineItem) {
        guard let targetURL = FileHelpers.selectHTMLFileToSave(withTitle: "Save item as HTML to")
        else { return }
        
        let baseHtml = htmlText(node: item)
        let htmlDocument = buildHtml(formattedNote: baseHtml, title: "Outline Print")
        do {
            try htmlDocument.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
            if openInFinder { openFolder(targetURL) }
            if openFile { openFile(targetURL) }
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    private func exportLegToHtml(item: OutlineItem) {
        guard let targetURL = FileHelpers.selectHTMLFileToSave(withTitle: "Save items as HTML to")
        else { return }

        var nodeList = NodeList()
        let fullHtml = nodeList.listNodeAndChildren(from: item)
                            .map({ htmlText(node: $0)})
                            .joined(separator: "\n<hr style=\"width: 50%;\">\n")
        
        let htmlDocument = buildHtml(formattedNote: fullHtml, title: "Outline Print")
        do {
            try htmlDocument.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
            if openInFinder { openFolder(targetURL) }
            if openFile { openFile(targetURL) }
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    // MARK: - Export to XML
    
    private func exportSingleToXml(treeFile: OpmlFile, item: OutlineItem) {
        guard let targetURL = FileHelpers.selectXMLFileToSave(withTitle: "Save item in XML format to")
        else { return }

        let document = treeFile.outlineXML(forRoot: item, includeChildren: false)
        do {
            try document.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
            if openInFinder { openFolder(targetURL) }
            if openFile { openFile(targetURL) }
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    private func exportLegToXml(treeFile: OpmlFile, item: OutlineItem) {
        guard let targetURL = FileHelpers.selectXMLFileToSave(withTitle: "Save items in XML format to")
        else { return }

        let document = treeFile.outlineXML(forRoot: item)
        do {
            try document.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
            if openInFinder { openFolder(targetURL) }
            if openFile { openFile(targetURL) }
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    // MARK: - Export to JSON
    private func exportSingleToJson(treeFile: OpmlFile, item: OutlineItem) {
        guard let targetURL = FileHelpers.selectJSONFileToSave(withTitle: "Save items in JSON format to")
        else { return }

        let tempItem = OutlineItem()
        tempItem.text = item.text
        tempItem.notes = item.notes
        tempItem.starred = item.starred
        tempItem.createdDate = item.createdDate
        tempItem.updatedDate = item.updatedDate
        tempItem.completedDate = item.completedDate
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let jsonData = try? encoder.encode(tempItem),
           let jsonText = String(data: jsonData, encoding: .utf8) {
            do {
                try jsonText.write(to: targetURL, atomically: true, encoding: .utf8)
                notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
                if openInFinder { openFolder(targetURL) }
                if openFile { openFile(targetURL) }
            } catch {
                Alerts.exportError(message: error.localizedDescription)
            }
        } else {
            Alerts.exportError(message: "There was nothing to export")
        }
    }
    
    private func exportLegToJson(treeFile: OpmlFile, item: OutlineItem) {
        guard let targetURL = FileHelpers.selectJSONFileToSave(withTitle: "Save items in JSON format to")
        else { return }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let jsonData = try? encoder.encode(item),
           let jsonText = String(data: jsonData, encoding: .utf8) {
            do {
                try jsonText.write(to: targetURL, atomically: true, encoding: .utf8)
                notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
                if openInFinder { openFolder(targetURL) }
                if openFile { openFile(targetURL) }
            } catch {
                Alerts.exportError(message: error.localizedDescription)
            }
        } else {
            Alerts.exportError(message: "There was nothing to export")
        }
    }
    
    // MARK: - Print helpers
    
    public func htmlDocument(item: OutlineItem) -> String {
        let baseHtml = htmlText(node: item)
        return buildHtml(formattedNote: baseHtml, title: "Outline Print")
    }
    
    public func htmlDocumentFromLeg(item: OutlineItem) -> String {
        let separator = includeSeparator ? "\n<hr style=\"width: 50%;\">\n" : ""
        var nodeList = NodeList()
        let fullHtml = nodeList.listNodeAndChildren(from: item)
            .map({ htmlText(node: $0)})
                            .joined(separator: separator)
        
        return buildHtml(formattedNote: fullHtml, title: "Outline Print")
    }
    
    // MARK: - Helper functions
    
    /// Converts the markdown to HTML
    ///
    /// - Parameter node: The node to be converted
    /// - Returns: A string containing the HTML representation of the markdown.
    func htmlText(node: OutlineItem) -> String {
        let noteText = includeTitle
            ? "# \(node.text)\n\(node.notes)"
            : node.notes
        
        let markdown = MarkdownParser.standard.parse(noteText)
        return HtmlGenerator.standard.generate(doc: markdown)
    }
    
    func buildHtml(formattedNote: String, title: String) -> String {
        
        let prefix = Constants.notePrintPrefixHtml
            .replacingOccurrences(of: "$$title$$", with: title)
        
        let suffix = Constants.notePrintSuffixHtml
        
        return "\(prefix)\n\(formattedNote)\n\(suffix)"
    }

    private func openFolder(_ folder: URL) {
        if folder.hasDirectoryPath {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: folder.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([folder])
        }
    }
    
    private func openFile(_ file: URL) {
        NSWorkspace.shared.open(file)
    }
}

enum ExportContent: String, CaseIterable, Identifiable, CustomStringConvertible {
    case single
    case leg
    
    var id: String { self.description }
    
    var description: String {
        switch self {
        case .single:
            return "Current Item"
        case .leg:
            return "Current Item and Children"
        }
    }
}

enum ExportFormat: String, CaseIterable, Identifiable, CustomStringConvertible {
    case html
    case xml
    case json
    
    var id: String { self.description }
    
    var description: String {
        switch self {
        case .html:
            return "HTML"
        case .xml:
            return "XML"
        case .json:
            return "JSON"
        }
    }
}
