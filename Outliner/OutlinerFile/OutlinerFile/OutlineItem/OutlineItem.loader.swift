//
// File: OutlineItem.loader.swift
// Package: OutlinerFile
// Created by: Steven Barnett on 10/06/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

extension OutlineItem {
    
    func populateFromAttributes(fromElement: XMLElement) {
        
        self.attributes = NodeHelpers.loadAttributes(fromElement: fromElement)
        
        text = attributes[OutlineItemField.text] ?? ""
        notes = attributes[OutlineItemField.notes] ?? ""
        completed = (attributes[OutlineItemField.completed] ?? "") == "checked"
        starred = (attributes[OutlineItemField.starred] ?? "") == "yes"
        isExpanded = (attributes[OutlineItemField.expanded] ?? "") == "yes"
        
        createdDate = dateFrom(attributes: attributes, forItem: OutlineItemField.createdDate)
        updatedDate = dateFrom(attributes: attributes, forItem: OutlineItemField.updatedDate)
        completedDate = dateFrom(attributes: attributes, forItem: OutlineItemField.completedDate)
    }
    
    func dateFrom(attributes: [String: String], forItem key: String) -> Date? {
        if let value = attributes[key] {
            return try? Date(value, strategy: .iso8601)
        }
        return nil
    }
    
    func loadChildren(fromElement parentNode: XMLElement) {
        
        let childNodes = parentNode.elements(forName: "outline")
        if childNodes.count == 0 { return }
        
        // Load the child nodes if there are any.
        for node in childNodes {
            let childNode = OutlineItem(fromOutlineNode: node, withParent: self)
            children.append(childNode)
        }
    }
}
