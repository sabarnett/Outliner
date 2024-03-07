//
// File: ThemeSettings.swift
// Package: Outline Tester
// Created by: Steven Barnett on 04/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ThemeSettings: View {
    @ObservedObject var settings: SettingsViewModel
    
    @State private var theme: ThemeDefinition = ThemeDefinition.example
    @State private var selection: ThemeItemType?
    @State private var fontFamily: String = "Default"
    @State private var fontSize: Int = 14
    @State private var fontWeight: ThemeFontWeight = .regular
    @State private var listId: UUID = UUID()
    
    var body: some View {
        VStack {
            List(ThemeItemType.allCases) { themeType in
                Text(themeType.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .themedFont(for: themeType)
                    .tag(themeType)
                    .onTapGesture {
                        selection = themeType
                        
                        theme = ThemeManager.shared.theme(for: themeType) ?? ThemeDefinition.example
                        fontFamily = theme.fontFamily
                        fontSize = Int(theme.fontSize)
                        fontWeight = theme.fontWeight
                    }
                    .listRowBackground(themeType == selection
                                       ? Color.accentColor.opacity(0.2)
                                       : Color.clear)
            }
            .id(listId)
            .frame(minHeight: 300)
            
            HStack {
                FontPicker(fontFamily: $fontFamily, fontSize: $fontSize, fontWeight: $fontWeight)
                Spacer()
                Button("Default") {
                    theme = ThemeDefinition.defaultTheme(for: theme.id)
                    fontFamily = theme.fontFamily
                    fontSize = Int(theme.fontSize)
                    fontWeight = theme.fontWeight
                }
            }
            .disabled(selection == nil)
            .onChange(of: fontFamily) { updateTheme() }
            .onChange(of: fontSize) { updateTheme() }
            .onChange(of: fontWeight) { updateTheme() }
        }
        .padding()
    }
    
    func updateTheme() {
        theme.fontFamily = fontFamily
        theme.fontSize = CGFloat(fontSize)
        theme.fontWeight = fontWeight
            
        ThemeManager.shared.updateTheme(to: theme)
        listId = UUID()
    }
}

#Preview {
    ThemeSettings(settings: SettingsViewModel())
}
