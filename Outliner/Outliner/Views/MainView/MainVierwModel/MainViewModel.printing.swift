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
        guard let window = NSApplication.shared.windows.first(
            where: {$0.windowNumber == self.windowNumber})
        else { return }
        
        let htmlDocument = Exporter().htmlDocument(item: selection)
        
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
        guard let window = NSApplication.shared.windows.first(
            where: {$0.windowNumber == self.windowNumber})
        else { return }
        
        let htmlDocument = Exporter().htmlDocumentFromLeg(item: selection)
        
        printView = HTMLPrintView()
        let options = PrintOptions(
            header: selection.text,
            htmlContent: htmlDocument,
            window: window
        )
        printView!.printView(printOptions: options)
    }
}
