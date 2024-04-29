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

public class OpmlFile {

    public var fileUrl: URL

    public var outline: OutlineBody!
    public var header: OutlineHeader!

    var fileNameWithExtension: String {
        return fileUrl.lastPathComponent
    }

    var fileNameWithoutExtension: String {
        return fileUrl.deletingPathExtension().lastPathComponent
    }

    init(fromUrl: URL) {
        fileUrl = fromUrl

        guard let doc = loadDocument(url: fromUrl) else {
            print("Document load failure")
            return
        }

        self.header = OutlineHeader(fromDocument: doc)
        self.outline = OutlineBody(fromDocument: doc)

        for olItem in self.outline!.outlineBody!.children {
            printStuff(olItem)
        }
    }

    private func loadDocument(url: URL) -> XMLDocument? {

        let options = XMLNode.Options()
        return try? XMLDocument(contentsOf: url, options: options)
    }

    private func printStuff(_ node: OutlineItem) {
        print(node.text)
        for child in node.children {
            printStuff(child)
        }
    }
}
