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
    
    // Print specific
    case heading1
    case heading2
    case heading3
    case heading4
    case heading5
    case heading6
    case paragraph
    case leadParagraph
    case body

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
            
        case .heading1:
            return "Heading 1"
        case .heading2:
            return "Heading 2"
        case .heading3:
            return "Heading 3"
        case .heading4:
            return "Heading 4"
        case .heading5:
            return "Heading 5"
        case .heading6:
            return "Heading 6"
        case .paragraph:
            return "Paragraph"
        case .leadParagraph:
            return "Leading Paragraph"
        case .body:
            return "Default text"
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
    
    // View/Print separators
    static var viewTypes: [ThemeItemType] {
        [ .itemTitle, .itemNotes,
          .sidebarHeading, .sidebarButton, .sidebarCounter,
          .nodePreviewTitle, .nodePreviewBody, .nodePreviewStatistics, .nodeEditTitle, .nodeEditNotes
        ]
    }
    
    static var printTypes: [ThemeItemType] {
        [.heading1, .heading2, .heading3, .heading4, .heading5, .heading6,
         .paragraph, .leadParagraph, .body]
    }
}
