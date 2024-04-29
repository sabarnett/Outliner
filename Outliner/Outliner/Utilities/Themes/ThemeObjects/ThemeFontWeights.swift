//
// File: ThemeFontWeights.swift
// Package: Outline Tester
// Created by: Steven Barnett on 03/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum ThemeFontWeight: String, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    
    case black
    case bold
    case heavy
    case light
    case medium
    case regular
    case semibold
    case thin
    case ultraLight
    
    // MARK: - Identifiable
    var id: String { return self.description }
    
    // MARK: - CustomStringConvertible
    var description: String {
        switch self {
        case .black:
            return "Black"
        case .bold:
            return "Bold"
        case .heavy:
            return "Heavy"
        case .light:
            return "Light"
        case .medium:
            return "Medium"
        case .regular:
            return "Regular"
        case .semibold:
            return "Semi Bold"
        case .thin:
            return "Thin"
        case .ultraLight:
            return "Ultra Light"
        }
    }
    
    // MARK: - Public interface
    var fontWeight: Font.Weight {
        switch self {
        case .black:
            return Font.Weight.black
        case .bold:
            return Font.Weight.bold
        case .heavy:
            return Font.Weight.heavy
        case .light:
            return Font.Weight.light
        case .medium:
            return Font.Weight.medium
        case .regular:
            return Font.Weight.regular
        case .semibold:
            return Font.Weight.semibold
        case .thin:
            return Font.Weight.thin
        case .ultraLight:
            return Font.Weight.ultraLight
        }
    }
}
