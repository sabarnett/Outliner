//
// File: ThemeManager.swift
// Package: Outline Tester
// Created by: Steven Barnett on 28/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

class ThemeManager {

    // MARK: - Local storage
    private var themeDefinitions: ThemeDefinitions
    
    // MARK: - Singleton initialisation
    public static let shared: ThemeManager = ThemeManager()
    private init() {
        themeDefinitions = ThemeStorage().loadThemes()
    }
    
    // MARK: - Public API
    
    /// Creates a Font definition for the selected theme.
    ///
    /// - Parameters:
    ///   - theme: The there name
    ///   - size: An optional override for the font size
    ///
    /// - Returns: A Font object for the selected theme.
    public func font(for theme: ThemeItemType, size: CGFloat?) -> Font {
        
        if let definition = themeDefinitions.definitions.first(where: { $0.id == theme }) {
            return definition.font(size: size)
        }
        
        // We don't have a definition, so use a default font
        return Font.system(size: 14)
    }
    
    /// Extract the theme definition for a specific theme type.
    ///
    /// - Parameter theme: The theme type to fetch the definition for
    ///
    /// - Returns: The ThemeDefinition for the specified type. returns nil if the theme isn't found.
    public func theme(for theme: ThemeItemType?) -> ThemeDefinition? {
        if let theme {
            return themeDefinitions.definitions.first(where: { $0.id == theme })
        }
        return nil
    }
    
    public func updateTheme(to theme: ThemeDefinition) {
        guard let themeIndex = themeDefinitions.definitions.firstIndex(where: {$0.id == theme.id}) else { return }
        themeDefinitions.definitions[themeIndex] = theme
        ThemeStorage().saveThemes(themeDefinitions)
        
        // Depending on the theme, we need to send out a refresh message
        // in order to get the views updated.
        if theme.id.isItemType {
            let notificationName = Notification.Name(AppNotifications.RefreshOutlineNotification)
            let notification = Notification(name: notificationName, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        } else if theme.id.isPreviewType {
            let notificationName = Notification.Name(AppNotifications.RefreshPreviewNotification)
            let notification = Notification(name: notificationName, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        } else {
            let notificationName = Notification.Name(AppNotifications.RefreshSidebarNotification)
            let notification = Notification(name: notificationName, object: nil, userInfo: nil)
            NotificationCenter.default.post(notification)
        }
    }
}
