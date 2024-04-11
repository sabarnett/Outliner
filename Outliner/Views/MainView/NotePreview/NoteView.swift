//
// File: NoteView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 31/01/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import MarkdownKit
import RegexBuilder

struct NoteView: View {
    @Environment(\.dismiss) private var dismiss
    
    var vm: NodeViewViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            NoteViewPreview(vm: vm)
                
            HStack {
                Spacer()
                Button("Close") { dismiss() }
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }.frame(width: 800, height: 700)
    }
}

struct NoteViewPreview: View {
    
    var vm: NodeViewViewModel
    private var node: OutlineItem {
        vm.node
    }

    @State var pageId: UUID = UUID()
    @State var showNoteSource: Bool = false
    @AppStorage("noteFontSize") private var noteFontSize: Double = 16
    @Environment(\.colorScheme) private var colorScheme
    
    private func createHilight(text: String, highlight: String) -> String {
        let regexText = "(\(highlight))"
        let replaceText = "<span class='highlight'>$search</span>"
        
        guard let regex = try? NSRegularExpression(pattern: regexText,
                                                   options: .caseInsensitive) else {
            // failed to create regex, return the original string
            return text
        }
        
        // Get the matches, so we have access to the original text
        let textRange = NSRange(location: 0, length: text.count)
        let resultValues = regex.matches(in: text, range: textRange)
        
        // Do the replacement
        var resultText = regex.stringByReplacingMatches(
            in: text,
            options: .withTransparentBounds,
            range: textRange,
            withTemplate: replaceText
        )
                
        // Now put the original text back
        for match in resultValues {
            if let textRange = Range(match.range, in: text) {
                let originalValue = text[textRange]
                resultText = resultText.replacing("$search", with: originalValue, maxReplacements: 1)
            }
        }
        
        return resultText

    }
    
    var htmlText: String {
        var noteText = node.notes
        
        // Do we need to highlight anything?
        if !vm.highlightText.isEmpty {
            noteText = createHilight(text: noteText, highlight: vm.highlightText)
        }

        let markdown = MarkdownParser.standard.parse(noteText)
        return buildHtml(formattedNote: HtmlGenerator.standard.generate(doc: markdown))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            previewToolbar()
                .disabled(node.notes.isEmpty)
            
            HilightedTextView(text: node.text, highlight: vm.highlightText)
                .themedFont(for: .nodePreviewTitle)
            
            previewDisplay()
            
            VStack(spacing: 1) {
                if let createdDate = node.createdDate {
                    Text("Created on: \(createdDate.formatted())")
                        .themedFont(for: .nodePreviewStatistics)
                }
                if let updatedDate = node.updatedDate {
                    Text("Last updated: \(updatedDate.formatted())")
                        .themedFont(for: .nodePreviewStatistics)
                }
                if let completedDate = node.completedDate {
                    Text("Completed on: \(completedDate.formatted())")
                        .themedFont(for: .nodePreviewStatistics)
                }
            }
        }
        .id(pageId)
        .onReceive(AppNotifications.refreshPreview) { _ in
            pageId = UUID()
        }
    }
    
    fileprivate func previewToolbar() -> some View {
        return HStack(spacing: 4) {
            switchDisplayStyleButton()
            ControlGroup {
                decreaseFontSizeButton()
                increaseFontSizeButton()
                resetFontSizeButton()
            }.frame(maxWidth: 80)
            copyToPasteboard()
        }.padding(.top, 12)
    }

    @ViewBuilder
    fileprivate func previewDisplay() -> some View {
        if node.notes.isEmpty {
                ContentUnavailableView(
                    "No Note",
                    systemImage: "doc.circle",
                    description: Text("There are no notes for this item.")
                )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
        } else if showNoteSource {
            ScrollView {
                HilightedTextView(text: node.notes, highlight: vm.highlightText)
                    .themedFont(for: .nodePreviewBody,
                        size: noteFontSize)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(.horizontal)
            }
        } else {
            HTMLView(htmlContent: htmlText)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
                .padding(.horizontal)
        }
    }
    
    fileprivate func switchDisplayStyleButton() -> some View {
        Button(action: {
            showNoteSource.toggle()
        }, label: {
            Image(systemName: showNoteSource
                  ? "doc.richtext"
                  : "doc.plaintext")
        })
        .help(showNoteSource
              ? "Show formatted text"
              : "Show plain text")
    }
    
    fileprivate func increaseFontSizeButton() -> some View {
        Button(action: {
            if noteFontSize < 32 {
                noteFontSize += 1
            }
        }, label: {
            Image(systemName: "textformat.size.larger")
                .scaleEffect(1.2)
        })
        .help("Make the text larger")
    }
    
    fileprivate func decreaseFontSizeButton() -> some View {
        Button(action: {
            if noteFontSize > 10 {
                noteFontSize -= 1
            }
        }, label: {
            Image(systemName: "textformat.size.smaller")
        })
        .help("Make  the text smaller")
    }
    
    fileprivate func resetFontSizeButton() -> some View {
        Button(action: {
            noteFontSize = 16
        }, label: {
            Image(systemName: "textformat.size")
        })
        .help("Reset the text size")
    }
    
    fileprivate func copyToPasteboard() -> some View {
        Button(action: {
            NSPasteboard.general.clearContents()
            if showNoteSource {
                NSPasteboard.general.setString(node.notes, forType: .string)
            } else {
                NSPasteboard.general.setString(htmlText, forType: .string)
            }
        }, label: {
            Image(systemName: "doc.on.clipboard")
        })
        .help("Reset the text size")
    }

    private func buildHtml(formattedNote: String) -> String {
        
        let foreground = colorScheme == .dark ? "whitesmoke" : "black"
        let background = colorScheme == .dark ? "black" : "white"
        let zoom = noteFontSize / 16
        
        let prefix = Constants.notePreviewPrefixHtml
            .replacingOccurrences(of: "$$title$$", with: node.text)
            .replacingOccurrences(of: "$$bgcolor$$", with: background)
            .replacingOccurrences(of: "$$fgcolor$$", with: foreground)
            .replacingOccurrences(of: "$$zoom$$", with: "\(zoom)")
        
        let suffix = Constants.notePreviewSuffixHtml
        
        return "\(prefix)\n\(formattedNote)\n\(suffix)"
    }
}

#Preview {
    NoteView(vm: NodeViewViewModel(node: OutlineItem(), highlightText: ""))
}
