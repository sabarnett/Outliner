//
// File: ExportSettings.swift
// Package: Outliner
// Created by: Steven Barnett on 11/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ExportSettings: View {

    @ObservedObject var settings: SettingsViewModel
    
    var body: some View {
        Form {
            
            Picker("Default Format", selection: $settings.exportDefaultFormat, content: {
                ForEach(ExportFormat.allCases) { format in
                    Text(format.description).tag(format)
                }
            })
            
            Picker("Default Content", selection: $settings.exportDefaultContent, content: {
                ForEach(ExportContent.allCases) { content in
                    Text(content.description).tag(content)
                }
            })

            Toggle(isOn: $settings.exportOpenFile,
                   label: { Text("Open file with default application.")})

            Toggle(isOn: $settings.exportOpenInFinder,
                   label: { Text("Open export folder in Finder.")})
        }
        .padding()
    }
}

#Preview {
    ExportSettings(settings: SettingsViewModel())
}
