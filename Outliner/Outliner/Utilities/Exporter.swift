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

struct Exporter {

    var notify = PopupNotificationCentre.shared

    // MARK: - Export to HTML
    
    public func exportSingleToHtml(item: OutlineItem) {
        guard let targetURL = FileHelpers.selectHTMLFileToSave(withTitle: "Save item as HTML to")
        else { return }
        
        let baseHtml = htmlText(node: item)
        let htmlDocument = buildHtml(formattedNote: baseHtml, title: "Outline Print")
        do {
            try htmlDocument.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    public func exportLegToHtml(item: OutlineItem) {
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
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    // MARK: - Export to XML
    
    public func exportSingleToXml(treeFile: OpmlFile, item: OutlineItem) {
        guard let targetURL = FileHelpers.selectXMLFileToSave(withTitle: "Save item in XML format to")
        else { return }

        let document = treeFile.outlineXML(forRoot: item, includeChildren: false)
        do {
            try document.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    public func exportLegToXml(treeFile: OpmlFile, item: OutlineItem) {
        guard let targetURL = FileHelpers.selectXMLFileToSave(withTitle: "Save items in XML format to")
        else { return }

        let document = treeFile.outlineXML(forRoot: item)
        do {
            try document.write(to: targetURL, atomically: true, encoding: .utf8)
            notify.showPopup(.saved, title: "Export Complete", description: "Export Complete")
        } catch {
            Alerts.exportError(message: error.localizedDescription)
        }
    }
    
    // MARK: - Print helpers
    
    public func htmlDocument(item: OutlineItem) -> String {
        let baseHtml = htmlText(node: item)
        return buildHtml(formattedNote: baseHtml, title: "Outline Print")
    }
    
    public func htmlDocumentFromLeg(item: OutlineItem) -> String {
        var nodeList = NodeList()
        let fullHtml = nodeList.listNodeAndChildren(from: item)
            .map({ htmlText(node: $0)})
                            .joined(separator: "\n<hr style=\"width: 50%;\">\n")
        
        return buildHtml(formattedNote: fullHtml, title: "Outline Print")
    }
    
    // MARK: - Helper functions
    
    /// Converts the markdown to HTML
    ///
    /// - Parameter node: The node to be converted
    /// - Returns: A string containing the HTML representation of the markdown.
    func htmlText(node: OutlineItem) -> String {
        let noteText = "# \(node.text)\n\(node.notes)"
        
        let markdown = MarkdownParser.standard.parse(noteText)
        return HtmlGenerator.standard.generate(doc: markdown)
    }
    
    func buildHtml(formattedNote: String, title: String) -> String {
        
        let prefix = Constants.notePrintPrefixHtml
            .replacingOccurrences(of: "$$title$$", with: title)
        
        let suffix = Constants.notePrintSuffixHtml
        
        return "\(prefix)\n\(formattedNote)\n\(suffix)"
    }

}
