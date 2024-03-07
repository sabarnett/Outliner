// Project: MacOutliner
//
// Copyright © 2019 Steven Barnett. All rights reserved. 
//
// Created by Steven Barnett on 29/01/2019
//
// License
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 

import Foundation

class NodeHelpers {

    public static func loadAttributes(fromElement element: XMLElement) -> [String: String] {

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

    public static func getStringValue(fromNode: XMLElement, forName: String, usingDefault: String = "") -> String {

        let node = fromNode.elements(forName: forName)
        if node.count == 0 { return usingDefault }

        return node[0].stringValue ?? usingDefault
    }

    public static func getFirstNode(fromDocument: XMLDocument, forPath: String) -> XMLElement? {

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
