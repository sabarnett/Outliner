//
// File: View+ThemedFont.swift
// Package: Outline Tester
// Created by: Steven Barnett on 01/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

extension View {
    func themedFont(for themeItem: ThemeItemType, size: CGFloat? = nil) -> some View {
        modifier(ThemedFont(for: themeItem, size: size))
    }
}
