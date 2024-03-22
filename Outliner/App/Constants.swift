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
    static let mainWindowSidebarMinWidth: CGFloat = 200

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
      </style>
    </head>
  <body>
"""
    
    static let notePreviewSuffixHtml = """
  </body>
</html>
"""
}
