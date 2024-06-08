//
// File: HTMLPrintView.swift
// Package: Outliner
// Created by: Steven Barnett on 05/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import WebKit

public struct PrintOptions {
    var fileName: String
    var header: String
    var footer: String = "\(Bundle.main.appName)\(Bundle.main.appVersionLong)"
    var htmlContent: String
    var window: NSWindow
}

public class HTMLPrintView: WKWebView, WKNavigationDelegate {
    private var pop: NSPrintOperation?
    private var printOptions: PrintOptions?

    // MARK: Initiate a print
    
    public func printView(printOptions: PrintOptions) {
        self.navigationDelegate = self
        self.printOptions = printOptions
        self.loadHTMLString(printOptions.htmlContent, baseURL: nil)
    }
    
    // MARK: Callback when page loaded
    
    @objc public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let printOptions = self.printOptions else { return }
        
        DispatchQueue.main.async {
            let printInfo = NSPrintInfo()
            printInfo.horizontalPagination = .fit
            printInfo.verticalPagination = .fit
            printInfo.topMargin = 60
            printInfo.bottomMargin = 60
            printInfo.leftMargin = 40
            printInfo.rightMargin = 40
            printInfo.isVerticallyCentered = false
            printInfo.isHorizontallyCentered = false
            
            self.pop = self.printOperation(with: printInfo)
            
            self.pop!.printPanel.options.insert(.showsPaperSize)
            self.pop!.printPanel.options.insert(.showsOrientation)
            self.pop!.printPanel.options.insert(.showsPreview)
            self.pop!.view?.frame = NSRect(x: 0.0, y: 0.0, width: 300.0, height: 900.0)
            
            self.pop!.runModal(
                for: printOptions.window,
                delegate: self,
                didRun: #selector(self.didRun),
                contextInfo: nil
            )
        }
    }
    
    @objc func didRun() {
        self.printOptions = nil
        self.pop = nil
    }

    // MARK: Page headers and footers
    
    fileprivate func addHeadings(_ printOptions: PrintOptions,
                                 _ pop: NSPrintOperation,
                                 _ borderSize: NSSize) {
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 10),
            .foregroundColor: NSColor.black
        ]
        let headerString = NSAttributedString(string: printOptions.header, attributes: headerAttributes)
        headerString.draw(at: NSPoint(x: 30, y: borderSize.height - 50))
    }
    
    fileprivate func addFooters(_ printOptions: PrintOptions,
                                _ pop: NSPrintOperation,
                                _ borderSize: NSSize) {
        let footerAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 9),
            .foregroundColor: NSColor.black
        ]
        
        let footer = "\(printOptions.fileName)\n\(printOptions.footer)"
        let footerString = NSAttributedString(string: footer, attributes: footerAttributes)
        footerString.draw(at: NSPoint(x: 30, y: 30))
        
        let pageString = NSAttributedString(string: "Page \(pop.currentPage)", attributes: footerAttributes)
        pageString.draw(at: NSPoint(x: borderSize.width - 80, y: 30))
    }
    
    /// Draws the headers and footers on the page
    ///
    /// - Parameter borderSize: The size of the page into which we want to print the headers and footers
    ///
    public override func drawPageBorder(with borderSize: NSSize) {
        super.drawPageBorder(with: borderSize)
        
        guard let printOptions, let pop else { return }
        
        addHeadings(printOptions, pop, borderSize)
        addFooters(printOptions, pop, borderSize)
    }
}
