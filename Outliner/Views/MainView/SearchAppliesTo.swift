//
// File: SearchAppliesTo.swift
// Package: Outline Tester
// Created by: Steven Barnett on 07/04/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

enum SearchAppliesTo: String, Identifiable, CaseIterable, Equatable, CustomStringConvertible {
    case titleAndNotes
    case titleOnly
    case notesOnly

    var id: String {
        return self.description
    }

    var description: String {
        switch self {
        case .titleAndNotes:
            return "Title & Notes"
        case .titleOnly:
            return "Title"
        case .notesOnly:
            return "Notes"
        }
    }
}
