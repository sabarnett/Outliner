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

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return closeAppWhenLastWindowCloses
    }
}
