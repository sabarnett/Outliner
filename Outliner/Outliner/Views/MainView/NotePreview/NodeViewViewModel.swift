//
// File: NoteViewParameters.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import OutlinerFile

struct NodeViewViewModel: Identifiable {
    var id: UUID = UUID()
    var node: OutlineItem
    var highlightText: String
}
