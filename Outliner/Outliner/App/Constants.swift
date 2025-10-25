//
// File: App.swift
// Package: Outliner
// Created by: Steven Barnett on 15/08/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct Constants {
    // Main window
    static let mainWindowWidth: CGFloat = 800
    static let mainWindowHeight: CGFloat = 500
    static let mainWindowMinWidth: CGFloat = 160
    static let mainWindowMinHeight: CGFloat = 160
    static let mainWindowSidebarMinWidth: CGFloat = 220

    // About box
    static let homeUrl: URL = URL(string: "http://www.sabarnett.co.uk")!
    static let homeAddress: String = "App support page"
    static let appDescription = "This application has been designed to " +
            "created outlines. It allows you to organise your thoughts " +
            "in a logical way and to break down large tasks into sub-tasks " +
            "to simplify the process of implementing them."

    // Settings window width
    static let settingsWindowWidth: CGFloat = 550
    static let settingsWindowLabelWidth: CGFloat = 220
    
    // Dialog default size
    static let dialogWidth: CGFloat = 700
    static let dialogHeight: CGFloat = 640
    
    // AppStorage
    static let recentFileCount = "recentFileCount"
    static let durationForRecentFilters = "recentFileFilters"
    static let displayMode = "displayMode"
    static let previewLineCount = "previewLineCount"
    static let alternatingRows = "alternatingRows"
    static let closeAppWhenLastWindowCloses = "closeAppWhenLastWindowCloses"
    static let searchAppliesTo = "searchAppliesTo"
    static let showInspector = "showInspector"
    static let exportOpenInFinder = "exportOpenInFinder"
    static let exportOpenFile = "exportOpenFile"
    static let exportDefaultFormat = "exportDeafultFormat"
    static let exportDefaultContent = "exportDefaultContent"
    static let printIncludeTitle = "printIncludeTitle"
    static let printIncludeSeparator = "printIncludeSeparator"
    static let sidebarVisible = "sidebarVisible"
    static let previewVisible = "previewVisible"
    static let previewWidth = "previewWidth"

    // Note preview
    static let notePreviewPrefixHtml = """
<!DOCTYPE html>
  <html>
    <head>
      <title>$$title$$</title>
      <meta charset="UTF-8">
      <style>
        body {
          background-color: $$bgcolor$$; color: $$fgcolor$$; zoom: $$zoom$$
        }
        .highlight {
            font-size: 1em;
            background-color: yellow;
            color: black;
        }
      </style>
    </head>
  <body>
"""
    
    static let notePreviewSuffixHtml = """
  </body>
</html>
"""

    // Note printing
    static let notePrintPrefixHtml = """
<!DOCTYPE html>
  <html>
    <head>
      <title>$$title$$</title>
      <meta charset="UTF-8">
      <style>
$$styleSheet$$

      </style>
    </head>
  <body>
"""
    
    static let notePrintSuffixHtml = """
  </body>
</html>
"""

    // Pasteboard related
    static let outlinePasteboardType: String = "uk.co.sabarnett.OutlinePasteboardType"
}
