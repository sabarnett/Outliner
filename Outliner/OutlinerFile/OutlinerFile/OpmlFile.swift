// Project: MacOutliner
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//
// Created by Steven Barnett on 29/01/2019
//

import Foundation
import OutlinerViews

public class OpmlFile {

    private var fileUrl: URL

    // MARK: - Public Variables
    
    public var outline: OutlineBody!
    public var header: OutlineHeader!
    
    public var fileNameWithExtension: String { return fileUrl.lastPathComponent }
    public var fileNameWithoutExtension: String { return fileUrl.deletingPathExtension().lastPathComponent }
    
    // MARK: - Initialisation
    
    /// Initialise an empty (new) outline file
    public init() {
        fileUrl = URL(string: "newFile")!
        
        let doc = XMLDocument()
        outline = OutlineBody(fromDocument: doc)
        header = OutlineHeader(fromDocument: doc)
    }
    
    /// Initialise an outline from a file.
    ///
    /// - Parameter fromUrl: The URL of the file to load
    public init(fromUrl: URL) throws {
        fileUrl = fromUrl

        guard let doc = try loadDocument(url: fromUrl) else {
            throw OpmlFileErrors.loadError(message: "Load failed for document.")
        }

        self.header = OutlineHeader(fromDocument: doc)
        self.outline = OutlineBody(fromDocument: doc)
    }
    
    // MARK: - Load and save API functions
    
    /// Saves the outline to a file. It is assumed that the file e write to is the same
    /// as the file we loaded. However, we can specify a new file to write to by
    /// including the 'targetUrl' parameter. If this is specified, when we override
    /// the loaded file URL and use the new target.
    ///
    /// - Parameter targetUrl: The URL of the file to save to. If not specified we
    /// use the URL of the file that was loaded.
    public func saveOutline(to targetUrl: URL? = nil) throws {
        
        if let targetUrl { fileUrl = targetUrl }
        
        let rootDoc = createDocument()
        let content = formatDocument(rootDoc)
        try writeDocument(content)
        
        // Clear the updated flags
        outline.outlineBody?.clearChangedIndicator()
    }
    
    /// Renders the XML for an outline file and returns it as a string.
    ///
    /// - Parameter root: Optional root OutlineItem or nil to use thw whole file.
    /// - Returns:  A string representation of the OpmlFile
    ///
    /// By default, the XML is for the entire outline. However, you can pass an optional
    /// OutlineItem and the XML will be rendered using that as t he root node. This gives
    /// a partial rendering of the file. This XML can be used to create a subset file or to
    /// create a string containing the subset that can be copied to the clipboard.
    ///
    /// When you are ready to paste the data, you can use the ``itemsFromXML(xml:)`` function
    /// to extract the tree structure of ``OutlineItem`` nodes.
    public func outlineXML(forRoot root: OutlineItem? = nil) -> String {
        let rootDoc = createDocument(forRoot: root)
        let content = formatDocument(rootDoc)

        return content
    }
    
    /// Converts a string containing an outline file definition into a tree structure of
    /// outline items.
    ///
    /// - Parameter xml: The XML definition of the outline file
    /// - Returns: The root node of the tree structure
    ///
    /// This function is used when we want to copy and paste a structure. The copy
    /// function will create an XML string by calling the outlineXML function. This converts
    /// all or part of a tree structure to XML. The paste function will call ``itemsFromXML(xml:)``
    /// to convert the extracted data back into a tree structure of OutlineItems.
    public func itemsFromXML(xml: String) throws -> OutlineItem? {
        guard let doc = try loadDocument(xml: xml) else {
            throw OpmlFileErrors.loadError(message: "Document failed to load - check the file format.")
        }

        let outline = OutlineBody(fromDocument: doc)
        return outline.outlineBody?.children.first
    }
    
    // MARK: - Private helpers
    
    private func loadDocument(url: URL) throws -> XMLDocument? {

        let options = XMLNode.Options()
        do {
            let fileContent = try String(contentsOfFile: url.path)
            return try XMLDocument(xmlString: fileContent, options: options)
        } catch {
            throw OpmlFileErrors.loadError(message: error.localizedDescription)
        }
    }
    
    private func loadDocument(xml: String) throws -> XMLDocument? {

        let options = XMLNode.Options()
        do {
            return try XMLDocument(xmlString: xml, options: options)
        } catch {
            throw OpmlFileErrors.loadError(message: error.localizedDescription)
        }
    }

    private func createDocument(forRoot root: OutlineItem? = nil) -> XMLDocument {
        let rootElement = XMLElement(name: "opml")
        let rootDoc = XMLDocument(rootElement: rootElement)
        
        self.header.renderXML(rootElement)
        if let root {
            let topLevel = OutlineItem()
            topLevel.children.append(root)
            let outlineBody = OutlineBody(fromItem: topLevel)
            outlineBody.renderXML(rootElement)
        } else {
            self.outline.renderXML(rootElement)
        }
        
        return rootDoc
    }
    
    private func formatDocument(_ document: XMLDocument) -> String {
        let options: XMLNode.Options = [.documentTidyXML,
                                        .nodePrettyPrint,
                                        .nodeUseSingleQuotes]

        return document.xmlString(options: options)
                      .replacingOccurrences(of: "#NewLine#", with: "&#xA;")
    }
    
    private func writeDocument(_ document: String) throws {
        let outputURL = URL(fileURLWithPath: fileUrl.path)
        do {
            try document.write(to: outputURL, atomically: true, encoding: .utf8)
        } catch {
            throw OpmlFileErrors.saveError(message: error.localizedDescription)
//            Alerts.saveError(message: error.localizedDescription)
        }
    }
}

public enum OpmlFileErrors: Error {
    case saveError(message: String)
    case loadError(message: String)
}
