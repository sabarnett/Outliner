//
// File: OutlinerApp.swift
// Package: Outliner
// Created by: Steven Barnett on 13/08/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

@main
struct OutlinerApp: App {

    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .auto
    
    let outlineManager: OutlineManager = OutlineManager()

    var body: some Scene {
        WindowGroup {
            // The opening window is not a data window. It is a front end
            // starter window designed to give the user a quick way to
            // reopen files.
            OpeningView()
                .onAppear { setDisplayMode() }
                .environmentObject(outlineManager)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        
        .onChange(of: displayMode) {
            setDisplayMode()
        }

        .commands {
            Menus(outlineManager: outlineManager)
        }

        Settings {
            SettingsView()
        }
    }

    fileprivate func setDisplayMode() {
        switch displayMode {
        case .light:
            NSApp.appearance = NSAppearance(named: .aqua)
        case .dark:
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case .auto:
            NSApp.appearance = nil
        }
    }
}
