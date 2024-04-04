//
// File: Menus.swift
// Package: Mac Template App
// Created by: Steven Barnett on 12/09/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

struct Menus: Commands {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var outlineManager: OutlineManager
    
    init(outlineManager: OutlineManager) {
        self.outlineManager = outlineManager
    }
    
    var body: some Commands {
        ToolbarCommands()
        SidebarCommands()
        EditCommands()
        
        // Replace the About menu item.
        CommandGroup(replacing: CommandGroupPlacement.appInfo) {
            Button("About \(Bundle.main.appName)") {
                appDelegate.showAboutWnd()
            }
        }
        
        CommandGroup(before: CommandGroupPlacement.help) {
            Link(Constants.homeAddress,
                 destination: Constants.homeUrl)
            Divider()
        }
        
        FileCommands(outlineManager: outlineManager)
        
        CommandGroup(replacing: CommandGroupPlacement.undoRedo) {
            EmptyView()
        }
        
        ViewCommands()
        TreeCommands(outlineManager: outlineManager)
    }
}
