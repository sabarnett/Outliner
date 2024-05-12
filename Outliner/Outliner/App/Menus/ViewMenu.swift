//
// File: ViewMenu.swift
// Package: Outline Tester
// Created by: Steven Barnett on 05/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

public struct ViewCommands: Commands {
    
    @AppStorage(Constants.showInspector) private var showInspector: Bool = true
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .auto

    public var body: some Commands {
        CommandGroup(before: .sidebar) {
            Button(showInspector ? "Hide Note Preview" : "Show Note Preview") {
                showInspector.toggle()
            }
        }
        
        CommandGroup(before: .sidebar) {
            Picker(selection: $displayMode, content: {
                ForEach(DisplayMode.allCases) { mode in
                    Text(mode.description).tag(mode)
                }
            }, label: {
                Text("Display mode")
            })
            Divider()
        }
    }
}
