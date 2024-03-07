//
// File: View+Extensions.swift
// Package: Outline Tester
// Created by: Steven Barnett on 31/01/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

extension View {
    @discardableResult
    func openInWindow(title: String, representedFile: String, sender: Any?,
                      atLocation: CGPoint = CGPoint(x: 0, y: 0),
                      withSize size: CGSize = CGSize(width: 0, height: 0)) -> NSWindow {
        
        let windowWidth: CGFloat = size.width > 0
            ? size.width
            : ((NSScreen.main?.frame.size.width ?? Constants.mainWindowWidth) * 0.75)
        let windowHeight: CGFloat = size.height > 0
            ? size.height
            : ((NSScreen.main?.frame.size.height ?? Constants.mainWindowHeight) * 0.75)
        
        let windowLocation: CGPoint = atLocation
        
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        win.contentViewController = controller
        win.styleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        win.setFrame(NSRect(x: windowLocation.x, y: windowLocation.y,
                            width: windowWidth, height: windowHeight), display: false)
        win.title = title
        win.representedFilename = representedFile
        win.makeKeyAndOrderFront(sender)
        
        if windowLocation.x == 0 {
            win.center()
        }
        return win
    }
    
    func openModal(title: String, sender: Any?) {
        
        let windowWidth = 700
        let windowHeight = 600
        
        let controller = NSHostingController(rootView: self)
        let win = ModalWindow(contentViewController: controller)
        win.contentViewController = controller
        win.setFrame(NSRect(x: 0, y: 0,
                            width: windowWidth, height: windowHeight), display: true)
        win.styleMask = [.titled, .closable, .resizable, .fullSizeContentView]
        win.title = title
        win.center()
        win.makeKeyAndOrderFront(sender)
        
        NSApp.runModal(for: win)
    }
    
}

final class ModalWindow: NSWindow {
    override func becomeKey() {
        super.becomeKey()
        
        level = .statusBar
    }
    
    override func close() {
        super.close()
        
        NSApp.stopModal()
    }
}
