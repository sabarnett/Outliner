//
// File: NodeEdit.swift
// Package: Outline Tester
// Created by: Steven Barnett on 11/02/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import MarkdownKit
import OutlinerViews

struct NodeEdit: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @ObservedObject var vm: NodeEditViewModel
    @AppStorage("noteFontSize") private var noteFontSize: Double = 16

    @State var viewPreview: Bool = false

    var htmlText: String {
        let markdown = MarkdownParser.standard.parse(vm.notes)
        return buildHtml(formattedNote: HtmlGenerator.standard.generate(doc: markdown))
    }
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Spacer()
                    ImageToggle(
                        caption: "Completed",
                        checkedImageName: "checkmark.square",
                        uncheckedImageName: "square",
                        value: $vm.completed
                    )
                    .help("Indicates whether the item has been completed.")
                    
                    ImageToggle(
                        caption: "Starred",
                        checkedImageName: "star.fill",
                        uncheckedImageName: "star",
                        value: $vm.starred
                    )
                    .help("Indicates whether the item has been flagged as important")
                }

                TextField("", text: $vm.text)
                    .themedFont(for: .nodeEditTitle)
                    .padding(.bottom)

                Section("Notes") {
                    Picker("", selection: $viewPreview) {
                        Text("Edit").tag(false)
                        Text("Preview").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 280)
                    
                    if viewPreview {
                        HTMLView(htmlContent: htmlText)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )
                            .padding(.horizontal)
                    } else {
                        TextEditor(text: $vm.notes)
                            .themedFont(for: .nodeEditNotes)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(nsColor: .tertiarySystemFill), lineWidth: 2))
                    }
                }
            }
            
            HStack {
                Spacer()
                Button("Save") {
                    vm.save()
                    dismiss()
                }
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .padding()
        .frame(width: 700, height: 600)
    }
    
    private func buildHtml(formattedNote: String) -> String {
        
        let foreground = colorScheme == .dark ? "whitesmoke" : "black"
        let background = colorScheme == .dark ? "black" : "white"
        let zoom = noteFontSize / 16
        
        let prefix = Constants.notePreviewPrefixHtml
            .replacingOccurrences(of: "$$title$$", with: vm.text)
            .replacingOccurrences(of: "$$bgcolor$$", with: background)
            .replacingOccurrences(of: "$$fgcolor$$", with: foreground)
            .replacingOccurrences(of: "$$zoom$$", with: "\(zoom)")
        
        let suffix = Constants.notePreviewSuffixHtml
        
        print("\(prefix)\n\(formattedNote)\n\(suffix)")
        return "\(prefix)\n\(formattedNote)\n\(suffix)"
    }

}

struct ImageToggle: View {
    
    var caption: String
    var checkedImageName: String
    var uncheckedImageName: String
    
    @Binding var value: Bool
    
    public var body: some View {
        HStack {
            Image(systemName: value ? checkedImageName : uncheckedImageName)
                .resizable()
                .frame(width: 18, height: 18)
                .onTapGesture {
                    value.toggle()
                }
            
            Text(caption)
        }
    }
}

#Preview {
    NodeEdit(vm: NodeEditViewModel(node: nil) { node, action in
    })
}
