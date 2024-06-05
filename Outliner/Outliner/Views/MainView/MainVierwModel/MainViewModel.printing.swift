//
// File: MainViewModel.printing.swift
// Package: Outliner
// Created by: Steven Barnett on 26/05/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import MarkdownKit
import OutlinerFile
import OutlinerViews
import SwiftUI

extension MainViewModel {
    
    func printSelected() {
        guard let selection else { return }
        let baseHtml = htmlText(node: selection)
        let htmlDocument = buildHtml(formattedNote: baseHtml, title: "Outline Print")
        
        guard let window = NSApplication.shared.windows.first(
            where: {$0.windowNumber == self.windowNumber})
        else { return }
        
        printView = HTMLPrintView()
        let options = PrintOptions(
            header: selection.text,
            htmlContent: htmlDocument,
            window: window
        )
        printView!.printView(printOptions: options)
    }
    
    func printSelectedLeg() {
        guard let selection else { return }
        
        var nodeList = NodeList()
        let fullHtml = nodeList.listNodeAndChildren(from: selection)
                            .map({ htmlText(node: $0)})
                            .joined(separator: "\n<hr style=\"width: 50%;\">\n")
        
        let htmlDocument = buildHtml(formattedNote: fullHtml, title: "Outline Print")
        
        guard let window = NSApplication.shared.windows.first(
            where: {$0.windowNumber == self.windowNumber})
        else { return }
        
        printView = HTMLPrintView()
        let options = PrintOptions(
            header: selection.text,
            htmlContent: htmlDocument,
            window: window
        )
        printView!.printView(printOptions: options)
    }
    
    /// Converts the markdown to HTML
    ///
    /// - Parameter node: The node to be converted
    /// - Returns: A string containing the HTML representation of the markdown.
    fileprivate func htmlText(node: OutlineItem) -> String {
        let noteText = "# \(node.text)\n\(node.notes)"
        
        let markdown = MarkdownParser.standard.parse(noteText)
        return HtmlGenerator.standard.generate(doc: markdown)
    }
    
    fileprivate func buildHtml(formattedNote: String, title: String) -> String {
        
        let prefix = Constants.notePrintPrefixHtml
            .replacingOccurrences(of: "$$title$$", with: title)
        
        let suffix = Constants.notePrintSuffixHtml
        
        return "\(prefix)\n\(formattedNote)\n\(suffix)"
    }
}
