//
// File: RecentFile.swift
// Package: Outline Tester
// Created by: Steven Barnett on 07/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

/// When a file is opened, we create a RecentFile entry for it and save it so that file can be reopened
/// from the opening screen or the recent files menu item. When the file is closed, we also save some
/// additional data about the window size and position, so we can restore it next time the file is
/// opened.
///
/// The data is persisted in JSON format so we can store multiple data points as a single string of data.
class RecentFile: Identifiable, Codable {

    var id: UUID = UUID()
    
    var fileURL: URL
    var fileName: String { fileURL.lastPathComponent.replacing("%20", with: " ") }
    var filePath: String { fileURL.deletingLastPathComponent().path }
    
    var width: CGFloat
    var height: CGFloat
    var locationX: CGFloat
    var locationY: CGFloat
    
    var previewOpen: Bool
    var previewWidth: CGFloat
    
    init(file: URL) {
        fileURL = file
        
        width = (NSScreen.main?.frame.size.width ?? Constants.mainWindowWidth) * 0.75
        height = (NSScreen.main?.frame.size.height ?? Constants.mainWindowHeight) * 0.75
        locationX = 0
        locationY = 0
        
        previewOpen = false
        previewWidth = 0.8
    }
    
    func setFrame(_ frame: NSRect) {
        width = frame.width
        height = frame.height
        locationX = frame.origin.x
        locationY = frame.origin.y
    }
    
    // MARK: - Codable implementation
    enum CodingKeys: String, CodingKey {
        case fileURL
        case width
        case height
        case locationX
        case locationY
        case previewOpen
        case previewWidth
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.fileURL = try container.decode(URL.self, forKey: .fileURL)
        self.width = try container.decode(CGFloat.self, forKey: .width)
        self.height = try container.decode(CGFloat.self, forKey: .height)
        self.locationX = try container.decode(CGFloat.self, forKey: .locationX)
        self.locationY = try container.decode(CGFloat.self, forKey: .locationY)
        
        self.previewOpen = try container.decodeIfPresent(Bool.self, forKey: .previewOpen) ?? false
        self.previewWidth = try container.decodeIfPresent(CGFloat.self, forKey: .previewWidth) ?? 0.8
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.fileURL, forKey: .fileURL)
        try container.encode(self.width, forKey: .width)
        try container.encode(self.height, forKey: .height)
        try container.encode(self.locationX, forKey: .locationX)
        try container.encode(self.locationY, forKey: .locationY)
        
        try container.encode(self.previewOpen, forKey: .previewOpen)
        try container.encode(self.previewWidth, forKey: .previewWidth)
    }
}

extension RecentFile: Equatable {
    static func == (lhs: RecentFile, rhs: RecentFile) -> Bool {
        lhs.id == rhs.id
    }
}

extension RecentFile: Hashable {
    public func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
    }
}
