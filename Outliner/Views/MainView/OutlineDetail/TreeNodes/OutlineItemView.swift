//
// File: OutlineItemView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 08/11/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineItemView: View {
    
    @EnvironmentObject var vm: MainViewModel
    @ObservedObject var node: OutlineItem
    @AppStorage(Constants.previewLineCount) var previewLineCount: Int = 1
    @State var titleEditEnabled: Bool = false
    @State var rowId: UUID = UUID()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                checkBox()
                VStack(alignment: .leading) {
                    nodeTitle()
                    nodeNotes()

                }.padding(.leading, 4)
            }.id(rowId)
        }
        .foregroundStyle(node.completed ? Color.primary.opacity(0.6) : Color.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    vm.selection = node
                }
        )
        .padding(.vertical, 4)
        .tag(node)
        .overlay { OutlineItemOverlayIcons(node: node) }
        .listRowBackground(node.id == vm.selection?.id
                           ? Color.accentColor.opacity(0.2)
                           : Color.clear)
        .onChange(of: vm.selection) { oldValue, newValue in
            if titleEditEnabled {
                titleEditEnabled = false
                rowId = UUID()      // Force list to refresh.
            }
        }
    }
    
    func checkBox() -> some View {
        VStack(alignment: .trailing) {
            // Checkbox and note icon
            Image(systemName: node.completed ? "checkmark.square" : "square")
                .scaleEffect(1.2)
                .onTapGesture {
                    node.completed.toggle()
                    vm.completeCount += node.completed ? 1 : -1
                }
                .padding(.leading, 8)
            if !node.notes.isEmpty {
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func nodeTitle() -> some View {
        if titleEditEnabled {
            TextField("Title", text: $node.text)
                .themedFont(for: .itemTitle)
                .onSubmit(of: .text) {
                    titleEditEnabled = false
                }
        } else {
            Text(node.text)
                .themedFont(for: .itemTitle)
                .onTapGesture {
                    titleEditEnabled = true
                }
        }
    }
    
    @ViewBuilder
    func nodeNotes() -> some View {
        if !node.notes.isEmpty {
            Text(node.notes)
                .lineLimit(0...previewLineCount)
                .themedFont(for: .itemNotes)
        } else {
            EmptyView()
        }
    }
}
