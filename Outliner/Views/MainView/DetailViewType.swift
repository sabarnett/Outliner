//
// File: DetailViewType.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

enum DetailViewType: CustomStringConvertible {
    case outline
    case completed
    case incomplete
    case starred
    case recentlyAdded
    case recentlyCompleted
    case recentlyUpdated
    
    var description: String {
        switch self {
        case .outline:
            return "Outline"
        case .completed:
            return "Completed"
        case .incomplete:
            return "Incomplete"
        case .starred:
            return "Starred"
        case .recentlyAdded:
            return "Recently Added"
        case .recentlyCompleted:
            return "Recently Completed"
        case .recentlyUpdated:
            return "Recently Updated"
        }
    }
    
    var toolbarImage: String {
        switch self {
        case .outline:
            return "outline"
        case .completed:
            return "complete"
        case .incomplete:
            return "incomplete"
        case .starred:
            return "starred"
        case .recentlyAdded:
            return "recentlyAdded"
        case .recentlyCompleted:
            return "recentlyCompleted"
        case .recentlyUpdated:
            return "recentlyUpdated"
        }
    }
}
