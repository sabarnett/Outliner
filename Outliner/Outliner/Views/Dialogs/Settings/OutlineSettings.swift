//
// File: OutlineSettings.swift
// Package: Outline Tester
// Created by: Steven Barnett on 20/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineSettings: View {
    @ObservedObject var settings: SettingsViewModel
    
    var body: some View {
        Form {
            Toggle(isOn: $settings.alternatingRows, label: {
                Text("Highlight alternating rows")
            })
            .padding(.bottom, 12)
            
            HStack {
                Stepper("Preview line count",
                    value: $settings.previewLineCount,
                    in: 4...15,
                    step: 1
                )
                Text("\(settings.previewLineCount.formatted())")
            }
            .padding(.bottom, 12)
            
            Picker("Search looks at", selection: $settings.searchAppliesTo) {
                ForEach(SearchAppliesTo.allCases) { search in
                    Text(search.description).tag(search)
                }
            }
        }
        .padding()
    }
}

#Preview {
    OutlineSettings(settings: SettingsViewModel())
}
