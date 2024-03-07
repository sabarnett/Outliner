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

class OutlineItem: CustomStringConvertible {

    var text: String = ""
    var notes: String = ""
    var status: String = ""
    var completed: Bool = false

    var visible: Bool = false

    var parent: OutlineItem?
    var children: [OutlineItem] = []
    var attributes: [String: String] = [:]

    var hasChildren: Bool { return children.count != 0 }

    var description: String { return text }

    init(fromOutlineNode: XMLElement, withParent: OutlineItem?) {
        self.parent = withParent

        populateFromAttributes(fromElement: fromOutlineNode)
        loadChildren(fromElement: fromOutlineNode)
    }

    private func loadChildren(fromElement parentNode: XMLElement) {

        let childNodes = parentNode.elements(forName: "outline")
        if childNodes.count == 0 { return }

        // Load the child nodes if there are any.
        for node in childNodes {
            let childNode = OutlineItem(fromOutlineNode: node, withParent: self)
            children.append(childNode)
        }
    }

    private func populateFromAttributes(fromElement: XMLElement) {

        self.attributes = NodeHelpers.loadAttributes(fromElement: fromElement)

        if let text = attributes["text"] {
            self.text = text
        }

        if let notes = attributes["_note"] {
            self.notes = notes
        }

        if let checked = attributes["_status"] {
            self.status = checked
            self.completed = checked == "checked"
        }
    }
}
