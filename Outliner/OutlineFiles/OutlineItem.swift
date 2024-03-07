// Project: MacOutliner
//
// Copyright © 2019 Steven Barnett. All rights reserved. 
//
// Created by Steven Barnett on 29/01/2019
// 

import Foundation

enum NodeExpansionState {
    case expanded
    case collapsed
}

enum NodeInsertionPoint {
    case above
    case below
    case child
}

struct OutlineItemField {
    static let text = "text"
    static let notes = "_note"
    static let completed = "_status"
    static let completedDate = "_completed"
    static let starred = "_star"
    static let starredDate = "_stardate"
    static let createdDate = "_created"
    static let updatedDate = "_updated"
    static let expanded = "_expanded"
}

class OutlineItem: CustomStringConvertible, Identifiable, ObservableObject, Hashable {

    static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    // MARK: - Publically available data
    
    @Published var id: UUID = UUID()
    
    @Published var text: String = "" {
        didSet { itemChanged() }
    }
    @Published var notes: String = "" {
        didSet { itemChanged() }
    }
    @Published var completed: Bool = false {
        didSet {
            completedDate = completed ? Date.now : nil
            itemChanged()
        }
    }
    @Published var starred: Bool = false {
        didSet { itemChanged() }
    }

    @Published var visible: Bool = false
    @Published var isExpanded: Bool = false

    // MARK: - Internal state
    
    var parent: OutlineItem?
    var children: [OutlineItem] = []
    var attributes: [String: String] = [:]

    var hasChildren: Bool { return children.count != 0 }

    var hasChanged: Bool = false
    var description: String { return text }
    var createdDate: Date?
    var updatedDate: Date?
    var completedDate: Date?

    // MARK: - Initialisation
    
    init() {
        self.parent = nil
        
        text = "New Outline"
        notes = ""
        completed = false
        starred = false
        children = []
        createdDate = Date.now
    }
    
    init(fromOutlineNode: XMLElement, withParent: OutlineItem?) {
        self.parent = withParent

        populateFromAttributes(fromElement: fromOutlineNode)
        loadChildren(fromElement: fromOutlineNode)
        
        hasChanged = false
    }
    
    // MARK: - Public methods
    
    func clearChangedIndicator() {
        hasChanged = false
        if hasChildren {
            for child in children {
                child.clearChangedIndicator()
            }
        }
    }
    
    /// Checks whether this itemor any of it's child items have been changed.
    ///
    /// - Returns: True if this or a child item has been changed, else false
    func dataHasChanged() -> Bool {
        if hasChanged { return true }
        
        let hasChanged = children.first(where: { $0.dataHasChanged() })
        return hasChanged == nil ? false : true
    }
    
    /// Creates an XML representation of the current item, which includes all of
    /// it's child items if any exist.
    ///
    /// - Parameter parent: The parent item of the current one, to which we will
    /// add our XML.
    func renderXML(_ parent: XMLElement) {
        let itemNode = XMLElement(name: "outline")

        for attr in createAttributes() {
            itemNode.addAttribute(attr)
            attributes.removeValue(forKey: attr.name!)
        }
        
        // Handle attributes that are not used by us but that may be in the file.
        if attributes.count > 0 {
            for attr in attributes {
                itemNode.addAttribute(XMLNode.attribute(withName: attr.key, stringValue: attr.value) as! XMLNode)
            }
        }
        
        parent.addChild(itemNode)
        if hasChildren {
            for child in children {
                child.renderXML(itemNode)
            }
        }
    }
    
    /// Set the expansion state of this node and all of it's child nodes to expanded or collapsed.
    /// 
    /// - Parameter state: Expand or Collapse the nodes
    func setExpansionState(to state: NodeExpansionState) {
        if hasChildren {
            for child in children {
                child.setExpansionState(to: state)
            }
        }
        
        isExpanded = state == .expanded
    }
    
    /// Creates a new item in the hierrchy
    ///
    /// - Parameters:
    ///   - node:  The node to be inserted into the hierarchy.
    ///   - relativePosition: The position of the new item relative to this item. You can
    ///   insert above, below or as a child of the current item.
    ///
    /// - Returns: The new node that was created.
    func addNewNode(node: OutlineItem, relativePosition: NodeInsertionPoint = .below) -> OutlineItem {
        
        let newNode = node
        newNode.hasChanged = true
        newNode.parent = parent

        switch relativePosition {
        case .above:
            if let parentNode = parent,
               let parentIndex = parentNode.children.firstIndex(where: {$0.id == id}) {
                
                parentNode.children.insert(newNode, at: parentIndex)
            }
        case .below:
            if let parentNode = parent,
               let parentIndex = parentNode.children.firstIndex(where: {$0.id == id}) {
                
                parentNode.children.insert(newNode, at: parentIndex + 1)
            }
        case .child:
            newNode.parent = self
            children.append(newNode)
            setExpansionState(to: .expanded)
        }

        return newNode
    }
    
    /// Deletes this item and all of it's child items from the hierarchy.
    func delete() -> OutlineItem? {
        var nextNode: OutlineItem?
        
        if let parentNode = parent,
           let parentIndex = parentNode.children.firstIndex(where: { $0.id == id }) {
            
            // work out what the next node will be
            if parentNode.children.count == 1 {
                // We are about to delete the only child, so the next selected
                // node should be the parent.
                nextNode = parent
            } else if parentNode.children.count > parentIndex + 1 {
                // We have nodes after the one we are deleting, so the next selected
                // is the next one below the one we are deleting.
                nextNode = parent?.children[parentIndex + 1]
            } else {
                // We know there are more than one node, but that there are no more
                // after the one we are deleting, so we step back to the previous
                // node at the child level.
                nextNode = parent?.children[parentIndex - 1]
            }
            
            parentNode.children.remove(at: parentIndex)
            parentNode.hasChanged = true
        }
        
        nextNode?.objectWillChange.send()
        return nextNode
    }
    
    // MARK: - Private helpers
    
    private func itemChanged() {
        updatedDate = Date.now
        hasChanged = true
        
        // Send out a message in case there is a preview loaded
        let notificationName = Notification.Name(AppNotifications.RefreshPreviewNotification)
        let notification = Notification(name: notificationName, object: nil, userInfo: nil)
        NotificationCenter.default.post(notification)
    }
    
    // MARK: - Private helpers - load the item

    fileprivate func populateFromAttributes(fromElement: XMLElement) {

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
    
    fileprivate func dateFrom(attributes: [String: String], forItem key: String) -> Date? {
        if let value = attributes[key] {
            return try? Date(value, strategy: .iso8601)
        }
        return nil
    }

    fileprivate func loadChildren(fromElement parentNode: XMLElement) {

        let childNodes = parentNode.elements(forName: "outline")
        if childNodes.count == 0 { return }

        // Load the child nodes if there are any.
        for node in childNodes {
            let childNode = OutlineItem(fromOutlineNode: node, withParent: self)
            children.append(childNode)
        }
    }
    
    // MARK: - Private helpers - save the item
    
    fileprivate func createAttributes() -> [XMLNode] {
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
    
    fileprivate func addDateAttribute(_ attributeArray: inout [XMLNode], from dateField: Date?, withName: String) {
        if let dateField {
            attributeArray.append(
                newAttribute(withName: withName, value: dateField.ISO8601Format())
            )
        }
    }
    
    fileprivate func newAttribute(withName: String, value: String) -> XMLNode {
        XMLNode.attribute(withName: withName, stringValue: value) as! XMLNode
    }
    
    // MARK: - Sample record
    static var example: OutlineItem {
        let sample = OutlineItem()
        sample.text = "Sample item title text"
        sample.notes = "Sample notes for the sample outline item\n\nWith additional text."
        return sample
    }
}
