// Project: MacOutliner
//
// Copyright © 2019 Steven Barnett. All rights reserved.
//
// Created by Steven Barnett on 29/01/2019
//

import Foundation

class NodeHelpers {

    static func loadAttributes(fromElement element: XMLElement) -> [String: String] {

        var attributeList = [String: String]()

        if let attributes = element.attributes {
            for attribute in attributes {
                if let attributeName = attribute.name,
                    let attributeValue = attribute.stringValue {

                    attributeList[attributeName] = attributeValue
                }
            }
        }

        return attributeList
    }

    static func getStringValue(fromNode: XMLElement, forName: String, usingDefault: String = "") -> String {

        let node = fromNode.elements(forName: forName)
        if node.count == 0 { return usingDefault }

        return node[0].stringValue ?? usingDefault
    }

    static func getFirstNode(fromDocument: XMLDocument, forPath: String) -> XMLElement? {

        do {
            let elements = try fromDocument.nodes(forXPath: forPath)
            if elements.count == 0 {
                return nil
            }

            return elements[0] as? XMLElement
        } catch {
            print(error)
            return nil
        }
    }
}
