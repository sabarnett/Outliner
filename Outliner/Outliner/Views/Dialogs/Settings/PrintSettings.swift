//
// File: ExportSettings.swift
// Package: Outliner
// Created by: Steven Barnett on 11/06/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PrintSettings: View {

    @ObservedObject var settings: SettingsViewModel
    
    var body: some View {
        Form {
            Toggle(isOn: $settings.printIncludeTitle,
                   label: {
                Text("Include item name as header")
            })

            Toggle(isOn: $settings.printIncludeSeparator,
                   label: {
                Text("Include separator between multiple items")
            })
        }
        .padding()
    }
}

#Preview {
    PrintSettings(settings: SettingsViewModel())
}
