//
// File: Alerts.swift
// Package: OutlinerViews
// Created by: Steven Barnett on 01/05/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

// swiftlint:disable identifier_name
public enum AlertResponseSaveDiscard {
    case save
    case discard
}
public enum AlertResponseDeleteCancel {
    case cancel
    case delete
}
public enum AlertResponseGeneric {
    case yes
    case no
    case cancel
}
// swiftlint:enable identifier_name

public struct Alerts {

    public init() { }
    
    @discardableResult
    public func openAlert(title: String, message: String, buttonTitles: [String] = []) -> NSApplication.ModalResponse {
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        
        for buttonTitle in buttonTitles {
            if buttonTitle.starts(with: "*") {
                let button = alert.addButton(withTitle: buttonTitle.replacing("*", with: "", maxReplacements: 1))
                button.bezelStyle = .rounded
                button.bezelColor = NSColor.systemRed
            } else {
                
                alert.addButton(withTitle: buttonTitle)
            }
        }
        
        NSApp.activate(ignoringOtherApps: true)
        
        let response = alert.runModal()
        return response
    }
}
