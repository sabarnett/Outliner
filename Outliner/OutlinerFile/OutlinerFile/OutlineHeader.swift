// Project: MacOutliner
//
// Copyright © 2019 Steven Barnett. All rights reserved.
//

import Foundation

public class OutlineHeader {
    public var title: String = ""
    public var expansionState: String = ""
    
    private var creationDate: String = ""
    private var lastSavedDate: String = ""

    public init(fromDocument doc: XMLDocument) {
        if let headerNode = NodeHelpers.getFirstNode(fromDocument: doc, forPath: "/opml/head") {
            self.title = NodeHelpers.getStringValue(fromNode: headerNode, forName: "title")
            self.expansionState = NodeHelpers.getStringValue(fromNode: headerNode, forName: "expansionState")
            self.creationDate = NodeHelpers.getStringValue(fromNode: headerNode, forName: "dateCreated")
            self.lastSavedDate = NodeHelpers.getStringValue(fromNode: headerNode, forName: "dateLastSaved")
        } else {
            self.title = "New Item"
            self.expansionState = ""
            self.creationDate = ""
            self.lastSavedDate = ""
        }
    }
    
    public func renderXML(_ parent: XMLElement) {
        lastSavedDate = Date.now.ISO8601Format()
        
        let headNode = XMLElement(name: "head")
        headNode.addChild(XMLElement(name: "title", stringValue: title))
        headNode.addChild(XMLElement(name: "expansionState", stringValue: expansionState))
        headNode.addChild(XMLElement(name: "dateCreated", stringValue: creationDate))
        headNode.addChild(XMLElement(name: "dateLastSaved", stringValue: lastSavedDate))

        parent.addChild(headNode)
    }
}
