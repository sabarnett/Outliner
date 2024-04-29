//
// File: Notifications.swift
// Package: Mac Template App
// Created by: Steven Barnett on 27/09/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

struct AppNotifications {
    // Refresh the preview window. Called when the settings are changed
    static let RefreshPreviewNotification: String = "refreshPreviewNotification"
    static var refreshPreview: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: Notification.Name(rawValue: AppNotifications.RefreshPreviewNotification))
    }
    
    // Refresh the sidebar. Called when the settings are changed
    static let RefreshSidebarNotification: String = "refreshSidebarNotification"
    static var refreshSidebar: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: Notification.Name(rawValue: AppNotifications.RefreshSidebarNotification))
    }
    
    // Refresh the outline/list. Called when the settings are changed
    static let RefreshOutlineNotification: String = "refreshOutlineNotification"
    static var refreshOutline: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: Notification.Name(rawValue: AppNotifications.RefreshOutlineNotification))
    }
}

struct SysNotifications {

    // System notifications that we want receive.
    static var willClose: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)
    }
    
    static var willTerminate: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)
    }
}
