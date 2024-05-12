//
// File: AppDelegate.swift
// Package: Outliner
// Created by: Steven Barnett on 15/08/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    @AppStorage(Constants.closeAppWhenLastWindowCloses) var closeAppWhenLastWindowCloses: Bool = true
    
    private var aboutBoxWindowController: NSWindowController?
    
    /// Displays a custom about box. The supplied one allows some minor
    /// customisation, but this gives us a free pass to create whatever we want
    /// in our about box.
    func showAboutWnd() {
        if aboutBoxWindowController == nil {
            let window = NSWindow()
            window.styleMask = [.closable, .titled]
            window.title = "About \(Bundle.main.appName)"
            window.contentView = NSHostingView(rootView: AboutView())
            window.center()
            aboutBoxWindowController = NSWindowController(window: window)
        }

        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
    
    /// The user can elect to close the app when the last data window closes or to leave the
    /// app open so they can open another file.
    ///
    /// - Returns: True if we should close the app else false.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return closeAppWhenLastWindowCloses
    }
}
