// Project: MacOutliner
//
// Copyright © 2019 Steven Barnett. All rights reserved. 
//

import Foundation

class OutlineHeader {
    public var title: String = ""
    public var expansionState: String = ""

    init(fromDocument doc: XMLDocument) {
        guard let headerNode = NodeHelpers.getFirstNode(fromDocument: doc, forPath: "/opml/head") else { return }

        self.title = NodeHelpers.getStringValue(fromNode: headerNode, forName: "title")
        self.expansionState = NodeHelpers.getStringValue(fromNode: headerNode, forName: "expansionState")
    }
}
