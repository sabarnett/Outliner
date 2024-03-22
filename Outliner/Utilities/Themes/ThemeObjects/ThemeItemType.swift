//
// File: ThemeItemType.swift
// Package: Outline Tester
// Created by: Steven Barnett on 01/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
enum ThemeItemType: String, CaseIterable, Identifiable, CustomStringConvertible {
    case itemTitle
    case itemNotes
    
    case sidebarHeading
    case sidebarButton
    case sidebarCounter
    
    case nodePreviewTitle
    case nodePreviewBody
    case nodePreviewStatistics
    
    case nodeEditTitle
    case nodeEditNotes
    
    // MARK: - Identifiable
    var id: String { self.description }
    
    // MARK: - CustomStringConvertable
    var description: String {
        switch self {
        case .itemTitle:
            return "Item Title"
        case .itemNotes:
            return "Item Notes"
        case .sidebarHeading:
            return "Sidebar Heading"
        case .sidebarButton:
            return "Sidebar Button"
        case .sidebarCounter:
            return "Sidebar Statistics Counter"
        case .nodePreviewTitle:
            return "Notes Preview Title"
        case .nodePreviewBody:
            return "Notes Preview Text"
        case .nodePreviewStatistics:
            return "Notes Preview Information"
        case .nodeEditTitle:
            return "Item Editor Title"
        case .nodeEditNotes:
            return "Item Editor Notes"
        }
    }
    
    // MARK: - Theme type grouping helpers
    var isItemType: Bool {
        self == .itemNotes || self == .itemTitle
    }
    var isPreviewType: Bool {
        self == .nodePreviewBody || self == .nodePreviewTitle || self == .nodePreviewStatistics
    }
    var isSidebarType: Bool {
        self == .sidebarButton || self == .sidebarCounter || self == .sidebarHeading
    }
}
