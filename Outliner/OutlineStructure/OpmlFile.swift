// Project: MacOutliner
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//
// Created by Steven Barnett on 29/01/2019
// 

import Foundation

class OpmlFile {

    private var fileUrl: URL

    // MARK: - Public Variables
    
    public var outline: OutlineBody!
    public var header: OutlineHeader!

    var fileNameWithExtension: String { return fileUrl.lastPathComponent }
    var fileNameWithoutExtension: String { return fileUrl.deletingPathExtension().lastPathComponent }
    
    // MARK: - Initialisation
    
    /// Initialise an empty (new) outline file
    init() {
        fileUrl = URL(string: "newFile")!
        
        let doc = XMLDocument()
        outline = OutlineBody(fromDocument: doc)
        header = OutlineHeader(fromDocument: doc)
    }
    
    /// Initialise an outline from a file.
    ///
    /// - Parameter fromUrl: The URL of the file to load
    init(fromUrl: URL) {
        fileUrl = fromUrl

        guard let doc = loadDocument(url: fromUrl) else {
            print("Document load failure")
            return
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
    func saveOutline(to targetUrl: URL? = nil) {
        
        if let targetUrl { fileUrl = targetUrl }
        
        let rootDoc = createDocument()
        let content = formatDocument(rootDoc)
        writeDocument(content)
        
        // Clear the updated flags
        outline.outlineBody?.clearChangedIndicator()
    }
    
    // MARK: - Private helpers
    
    private func loadDocument(url: URL) -> XMLDocument? {

        let options = XMLNode.Options()
        do {
            let fileContent = try String(contentsOfFile: url.path)
            return try XMLDocument(xmlString: fileContent, options: options)
        } catch {
            Alerts.loadError(message: error.localizedDescription)
            return nil
        }
    }
    
    private func createDocument() -> XMLDocument {
        let rootElement = XMLElement(name: "opml")
        let rootDoc = XMLDocument(rootElement: rootElement)
        
        self.header.renderXML(rootElement)
        self.outline.renderXML(rootElement)
        
        return rootDoc
    }
    
    private func formatDocument(_ document: XMLDocument) -> String {
        let options: XMLNode.Options = [.documentTidyXML,
                                        .nodePrettyPrint,
                                        .nodeUseSingleQuotes]

        return document.xmlString(options: options)
                      .replacingOccurrences(of: "#NewLine#", with: "&#xA;")
    }
    
    private func writeDocument(_ document: String) {
        let outputURL = URL(fileURLWithPath: fileUrl.path)
        do {
            try document.write(to: outputURL, atomically: true, encoding: .utf8)
        } catch {
            Alerts.saveError(message: error.localizedDescription)
        }
    }
}
