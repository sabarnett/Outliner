//
// File: ThemeDefinitions.swift
// Package: Outline Tester
// Created by: Steven Barnett on 01/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ThemeDefinition: Codable, Identifiable {
    
    var id: ThemeItemType = .itemNotes

    var fontFamily: String = "Default"
    var fontSize: CGFloat = 14
    var fontWeight: ThemeFontWeight = .regular
    
    // MARK: - Support for Codable
    enum CodingKeys: String, CodingKey {
        case id, fontFamily, fontSize, fontWeight
    }
    
    init(id: ThemeItemType, fontFamily: String = "Default", size: CGFloat, weight: ThemeFontWeight) {
        self.id = id
        self.fontFamily = fontFamily
        self.fontSize = size
        self.fontWeight = weight
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        decodeId(container: container)
        decodeFont(container: container)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.rawValue, forKey: .id)
        try container.encode(fontFamily, forKey: .fontFamily)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(fontWeight, forKey: .fontWeight)
    }
    
    // MARK: - Class helper functions
    public static var example: ThemeDefinition {
        ThemeDefinition(id: .itemTitle, fontFamily: "Default", size: 14, weight: .regular)
    }
    
    public static func defaultTheme(for theme: ThemeItemType) -> ThemeDefinition {
        switch theme {
        case .itemTitle:
            return ThemeDefinition(id: .itemTitle, size: 16, weight: .semibold)
        case .itemNotes:
            return ThemeDefinition(id: .itemNotes, size: 11, weight: .regular)
        case .sidebarHeading:
            return ThemeDefinition(id: .sidebarHeading, size: 18, weight: .bold)
        case .sidebarButton:
            return ThemeDefinition(id: .sidebarButton, size: 14, weight: .bold)
        case .sidebarCounter:
            return ThemeDefinition(id: .sidebarCounter, size: 14, weight: .regular)
        case .nodePreviewTitle:
            return ThemeDefinition(id: .nodePreviewTitle, size: 24, weight: .bold)
        case .nodePreviewBody:
            return ThemeDefinition(id: .nodePreviewBody, size: 14, weight: .regular)
        case .nodePreviewStatistics:
            return ThemeDefinition(id: .nodePreviewStatistics, size: 13, weight: .regular)
        case .nodeEditTitle:
            return ThemeDefinition(id: .nodeEditTitle, size: 20, weight: .regular)
        case .nodeEditNotes:
            return ThemeDefinition(id: .nodeEditNotes, size: 15, weight: .regular)
        }
    }

    // MARK: - The public interface for the theme definition
    
    /// Builds the required font based on the definition parameters.
    ///
    /// - Parameter size: An optional override for the font size.
    /// - Returns: The Font defined by the theme.
    func font(size: CGFloat?) -> Font {
        if fontFamily == "Default" {
            return Font.system(
                size: (size ?? self.fontSize),
                weight: self.fontWeight.fontWeight
            )
        }
        return Font.custom(fontFamily, size: size ?? self.fontSize)
            .weight(fontWeight.fontWeight)
    }

    // MARK: - Helper functions
    
    fileprivate mutating func decodeId(container: KeyedDecodingContainer<ThemeDefinition.CodingKeys>) {
        if let idString = try? container.decode(String.self, forKey: .id) {
            id = ThemeItemType(rawValue: idString)!
        } else {
            id = .itemTitle
        }
    }
    
    fileprivate mutating func decodeFont(container: KeyedDecodingContainer<ThemeDefinition.CodingKeys>) {
        if let family = try? container.decode(String.self, forKey: .fontFamily) {
            fontFamily = family
        }

        if let size = try? container.decode(CGFloat.self, forKey: .fontSize) {
            fontSize = size
        } else {
            fontSize = 12
        }

        if let weight = try? container.decode(ThemeFontWeight.self, forKey: .fontWeight) {
            fontWeight = weight
        } else {
            fontWeight = .regular
        }
    }
}

struct ThemeDefinitions: Codable {
    var fileVersion: Int
    var definitions: [ThemeDefinition]
}
