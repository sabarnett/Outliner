// Project: MacOutliner
//
// Copyright © 2019 Steven Barnett. All rights reserved.
//
// Created by Steven Barnett on 29/01/2019
//

import Foundation

public class OutlineBody {

    public var outlineBody: OutlineItem?
    
    public init(fromDocument doc: XMLDocument) {

        if let bodyNode = NodeHelpers.getFirstNode(fromDocument: doc, forPath: "/opml/body") {
            outlineBody = OutlineItem(fromOutlineNode: bodyNode, withParent: nil)
        } else {
            outlineBody = OutlineItem()
            outlineBody?.children.append(OutlineItem())
        }
    }
    
    public init(fromItem: OutlineItem) {
        outlineBody = fromItem
    }
    
    public func clearChangedIndicator() {
        outlineBody?.clearChangedIndicator()
    }
    
    public func renderXML(_ parent: XMLElement) {
        let bodyNode = XMLElement(name: "body")
        
        if let children = outlineBody?.children {
            for item in children {
                item.renderXML(bodyNode)
            }
        }
        
        parent.addChild(bodyNode)
    }
}
