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

class OutlineBody {

    var outlineBody: OutlineItem?
    
    init(fromDocument doc: XMLDocument) {

        if let bodyNode = NodeHelpers.getFirstNode(fromDocument: doc, forPath: "/opml/body") {
            outlineBody = OutlineItem(fromOutlineNode: bodyNode, withParent: nil)
        } else {
            outlineBody = OutlineItem()
            outlineBody?.children.append(OutlineItem())
        }
    }
    
    func clearChangedIndicator() {
        outlineBody?.clearChangedIndicator()
    }
    
    func renderXML(_ parent: XMLElement) {
        let bodyNode = XMLElement(name: "body")
        
        if let children = outlineBody?.children {
            for item in children {
                item.renderXML(bodyNode)
            }
        }
        
        parent.addChild(bodyNode)
    }
}
