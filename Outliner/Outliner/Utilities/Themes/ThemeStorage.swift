//
// File: ThemeStorage.swift
// Package: Outline Tester
// Created by: Steven Barnett on 02/03/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

class ThemeStorage {
    
    fileprivate let definitionsFileName = "ThemeDefinitions"
    
    // MARK: - Load/save themes
    
    /// Load the themes. If we have a saved themes file, this will be loaded, parsed and used to
    /// populate the ThemeDefinitions. If there is no saved themes file, a default one will be created
    /// and saved for next timee.
    ///
    /// - Returns: A populated theme definitions object.
    func loadThemes() -> ThemeDefinitions {
        var themeDefinitions = try? loadThemes()

        if themeDefinitions == nil {
            themeDefinitions = ThemeDefinitions(fileVersion: 0, definitions: [])
        }

        // Uncomment this line to reset the themes to a default state
//        themeDefinitions = ThemeDefinitions(fileVersion: 0, definitions: [])

        themeDefinitions = upgradeThemes(themeDefinitions!)
        
        return themeDefinitions!
    }
    
    /// Saves the themes structure to the themes file in the dcuments directory.
    ///
    /// - Parameter themeDefinitions: The ThemeDefinitions structure
    func saveThemes(_ themeDefinitions: ThemeDefinitions) {
        let fileMgr = FileManager.default
        let urls = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(definitionsFileName)
            fileURL = fileURL.appendingPathExtension("json")
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            guard let jsonData = try? encoder.encode(themeDefinitions) else {
                fatalError("Failed to serialise the theme")
            }
            try? jsonData.write(
                to: fileURL,
                options: [.atomicWrite]
            )
        }
        
    }
    
    // MARK: - Private helpers
    
    fileprivate func loadThemes() throws -> ThemeDefinitions? {
        
        let fileMgr = FileManager.default
        let urls = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(definitionsFileName)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try? decoder.decode(ThemeDefinitions.self, from: data)
        }
        return nil
    }
    
    /// Checks the version number of the theme file and applies any upgrades necessary to
    /// get the file up to the latest version.
    ///
    /// - Parameter themeDefinitions: The theme definitions structure
    /// - Returns: The updated theme definitions structure
    func upgradeThemes(_ themeDefinitions: ThemeDefinitions) -> ThemeDefinitions {
        
        var themeDef = themeDefinitions
        let startVersion = themeDefinitions.fileVersion
        
        if themeDef.fileVersion < 1 { themeDef = version1Upgrade(themeDef) }
        if themeDef.fileVersion < 2 { themeDef = version2Upgrade(themeDef) }
        // More conversions if needed
        
        if themeDef.fileVersion != startVersion {
            saveThemes(themeDef)
        }
        
        return themeDef
    }
    
    /// Version 1 of the file is the initial set of required themes for the basic app to function.
    ///
    /// - Parameter themeDefinitions: The theme definitions structure
    /// - Returns: The updated theme definitions structure
    fileprivate func version1Upgrade(_ themeDefinitions: ThemeDefinitions) -> ThemeDefinitions {
        var themeDef = themeDefinitions
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .itemTitle))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .itemNotes))
        
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .sidebarHeading))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .sidebarButton))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .sidebarCounter))
        
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .nodePreviewTitle))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .nodePreviewBody))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .nodePreviewStatistics))
        
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .nodeEditTitle))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .nodeEditNotes))
        
        themeDef.fileVersion = 1
        return themeDef
    }
    
    /// Version 2 of the file is the initial set of required themes for the basic app to function.
    ///
    /// - Parameter themeDefinitions: The theme definitions structure
    /// - Returns: The updated theme definitions structure
    ///
    /// This upgrade adds printing themes
    ///
    fileprivate func version2Upgrade(_ themeDefinitions: ThemeDefinitions) -> ThemeDefinitions {
        var themeDef = themeDefinitions
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .heading1))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .heading2))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .heading3))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .heading4))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .heading5))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .heading6))

        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .paragraph))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .leadParagraph))
        themeDef.definitions.append(ThemeDefinition.defaultTheme(for: .body))
        
        themeDef.fileVersion = 2
        return themeDef
    }
}
