//
// File: MainViewModel.export.swift
// Package: Outliner
// Created by: Steven Barnett on 06/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import OutlinerViews

extension MainViewModel {
    
    func exportSelectionToHTML() {
        guard let selection else { return }
        Exporter().exportSingleToHtml(item: selection)
    }
    
    func exportLegToHTML() {
        guard let selection else { return }
        Exporter().exportLegToHtml(item: selection)
    }
    
    func exportSelectionToXML() {
        guard let selection else { return }
        Exporter().exportSingleToXml(treeFile: treeFile, item: selection)
    }
    
    func exportLegToXML() {
        guard let selection else { return }
        Exporter().exportLegToXml(treeFile: treeFile, item: selection)
    }
}
