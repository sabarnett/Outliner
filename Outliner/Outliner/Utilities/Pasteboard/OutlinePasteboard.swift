//
// File: OutlinePasteboard.swift
// Package: Outliner
// Created by: Steven Barnett on 11/05/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import Foundation

/// Helper struct that encapsulates the data we want to put on the clipboard
struct OutlinePasteboard: Codable {
    var sourceFile: String
    var contentXML: String
}
