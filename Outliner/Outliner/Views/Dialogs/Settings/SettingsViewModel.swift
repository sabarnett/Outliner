//
// File: SettingsViewModel.swift
// Package: Mac Template App
// Created by: Steven Barnett on 21/08/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    // General tab options
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .auto
    @AppStorage(Constants.recentFileCount) var recentFileCount: Int = 5
    @AppStorage(Constants.durationForRecentFilters) var recentFileFilters: Int = 5

    // Tree settings
    @AppStorage(Constants.previewLineCount) var previewLineCount: Int = 1
    @AppStorage(Constants.alternatingRows) var alternatingRows: Bool = true
    @AppStorage(Constants.searchAppliesTo) var searchAppliesTo: SearchAppliesTo = .titleAndNotes

    // Advanced Settings extra options
    @AppStorage(Constants.closeAppWhenLastWindowCloses) var closeAppWhenLastWindowCloses: Bool = true

    // Export settings
    @AppStorage(Constants.exportOpenInFinder) var exportOpenInFinder: Bool = true
    @AppStorage(Constants.exportOpenFile) var exportOpenFile: Bool = false
    @AppStorage(Constants.exportDefaultFormat) var exportDefaultFormat: ExportFormat = .html
    @AppStorage(Constants.exportDefaultContent) var exportDefaultContent: ExportContent = .single
}
