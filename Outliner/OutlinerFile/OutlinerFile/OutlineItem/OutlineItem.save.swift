//
// File: OutlineItem.save.swift
// Package: OutlinerFile
// Created by: Steven Barnett on 10/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

extension OutlineItem {

    func createAttributes() -> [XMLNode] {
        var attributeArray: [XMLNode] = []

        attributeArray.append(XMLNode.attribute(withName: OutlineItemField.text, stringValue: text) as! XMLNode)
        if !notes.isEmpty {
            // Ok, this is a bit screwy. Creating the node will escape the stuff
            // we need to escape to make the string safe to write to the XML. What
            // it doesn't do, that Windows does, is escape the newline character to
            // &#xA; so we are going to have to do that ourselves. Problem is, if we
            // do that here, the & will be escaped to &amp; which means it won't be
            // decoded when we load the file. So, we're adding a placeholder here to be
            // replaced before the file is written.
            attributeArray.append(
                XMLNode.attribute(
                    withName: "_note",
                    stringValue: notes.replacingOccurrences(of: "\r", with: "")
                        .replacingOccurrences(of: "\n", with: "#NewLine#")
                ) as! XMLNode
            )
        }
        if completed {
            attributeArray.append(newAttribute(withName: OutlineItemField.completed, value: "checked"))
        } else {
            attributes.removeValue(forKey: OutlineItemField.completed)
        }
        if starred {
            attributeArray.append(newAttribute(withName: OutlineItemField.starred, value: "yes"))
        } else {
            attributes.removeValue(forKey: OutlineItemField.starred)
        }
        if isExpanded {
            attributeArray.append(newAttribute(withName: OutlineItemField.expanded, value: "yes"))
        } else {
            attributes.removeValue(forKey: OutlineItemField.expanded)
        }
        addDateAttribute(&attributeArray, from: completedDate, withName: OutlineItemField.completedDate)
        addDateAttribute(&attributeArray, from: createdDate, withName: OutlineItemField.createdDate)
        addDateAttribute(&attributeArray, from: updatedDate, withName: OutlineItemField.updatedDate)

        return attributeArray
    }

    func addDateAttribute(_ attributeArray: inout [XMLNode], from dateField: Date?, withName: String) {
        if let dateField {
            attributeArray.append(
                newAttribute(withName: withName, value: dateField.ISO8601Format())
            )
        }
    }

    func newAttribute(withName: String, value: String) -> XMLNode {
        XMLNode.attribute(withName: withName, stringValue: value) as! XMLNode
    }
}
