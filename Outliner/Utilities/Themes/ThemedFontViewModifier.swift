//
// File: View+ThemedFont.swift
// Package: Outline Tester
// Created by: Steven Barnett on 01/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ThemedFont: ViewModifier {
    
    var themeItem: ThemeItemType = .itemTitle
    var size: CGFloat?
    
    init(for themeItem: ThemeItemType, size: CGFloat? = nil) {
        self.themeItem = themeItem
        self.size = size
    }

    func body(content: Content) -> some View {
        content
            .font(ThemeManager.shared.font(for: themeItem, size: size))
    }
}

extension View {
    func themedFont(for themeItem: ThemeItemType, size: CGFloat? = nil) -> some View {
        modifier(ThemedFont(for: themeItem, size: size))
    }
}
