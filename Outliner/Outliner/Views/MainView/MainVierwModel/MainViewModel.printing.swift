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
import Cocoa
import WebKit
import SwiftUI

extension MainViewModel {
    
    func printSelected() {
        guard let selection else { return }
        let baseHtml = htmlText(node: selection)
        let htmlDocument = buildHtml(formattedNote: baseHtml, title: "Outline Print")
        
        guard let window = NSApplication.shared.windows.first(
            where: {$0.windowNumber == self.windowNumber})
        else { return }
        
        let printView = HTMLPrintView(htmlContent: htmlDocument, window: window)
        printView.printView()
    }
    
    func printSelectedLeg() {
        
    }
    
    /// Converts the markdown to HTML
    ///
    /// - Parameter node: The node to be converted
    /// - Returns: A string containing the HTML representation of the markdown.
    fileprivate func htmlText(node: OutlineItem) -> String {
        let noteText = "#\(node.text)\n\(node.notes)"
        
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

public class HTMLPrintView {
    let htmlContent: String
    let window: NSWindow
    
    public init(htmlContent: String, window: NSWindow) {
        self.htmlContent = htmlContent
        self.window = window
    }
    
    public func printView() {
        let webView = WKWebView(frame: .zero)
        
        webView.loadHTMLString(self.htmlContent, baseURL: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let printInfo = NSPrintInfo()
            printInfo.horizontalPagination = .fit
            printInfo.verticalPagination = .fit
            printInfo.topMargin = 40
            printInfo.bottomMargin = 60
            printInfo.leftMargin = 40
            printInfo.rightMargin = 40
            printInfo.isVerticallyCentered = true
            printInfo.isHorizontallyCentered = true
            
            let printOperation = webView.printOperation(with: printInfo)
            
            printOperation.printPanel.options.insert(.showsPaperSize)
            printOperation.printPanel.options.insert(.showsOrientation)
            printOperation.printPanel.options.insert(.showsPreview)
            printOperation.view?.frame = NSRect(x: 0.0, y: 0.0, width: 300.0, height: 300.0)
            
            printOperation.runModal(for: self.window, delegate: nil, didRun: nil, contextInfo: nil)
        }
    }
}
