//
// File: OutlineItem.encodable.swift
// Package: OutlinerFile
// Created by: Steven Barnett on 09/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

extension OutlineItem: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case text = "title"
        case notes
        case children
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(notes, forKey: .notes)
        try container.encode(children, forKey: .children)
    }

}
