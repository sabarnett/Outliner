//
// File: SettingsView.swift
// Package: Mac Template App
// Created by: Steven Barnett on 19/08/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    @StateObject private var settings = SettingsViewModel()

    var body: some View {
        TabView {
            GeneralSettings(settings: settings)
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            OutlineSettings(settings: settings)
                .tabItem {
                    Label("Outline", systemImage: "list.bullet.indent")
                }

            ThemeSettings(settings: settings)
                .tabItem {
                    Label("Styles", systemImage: "textformat")
                }

            AdvancedSettings(settings: settings)
                .tabItem {
                    Label("Advanced", systemImage: "gearshape.2")
                }
        }
        .frame(width: Constants.settingsWindowWidth)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
