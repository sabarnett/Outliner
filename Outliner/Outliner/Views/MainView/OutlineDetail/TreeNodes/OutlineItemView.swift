//
// File: OutlineItemView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 08/11/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerFile

struct OutlineItemView: View {
    
    @EnvironmentObject var vm: MainViewModel
    @ObservedObject var node: OutlineItem
    
    @State private var titleEditEnabled: Bool = false
    @State internal var isTargeted: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                OutlineItemCheckBox(node: node)
                VStack(alignment: .leading) {
                    OutlineItemNodeTitle(node: node, titleEditEnabled: $titleEditEnabled)
                    OutlineItemNodeNotes(node: node)
                }
            }
        }
        .id(node.id)
        .foregroundStyle(node.completed ? Color.primary.opacity(0.6) : Color.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .simultaneousGesture(TapGesture().onEnded { _ in vm.selection = node })
        .padding(.vertical, 4)
        .tag(node)
        .overlay { OutlineItemOverlayIcons(node: node) }
        .listRowBackground(listRowBackgroundColor())
        
        .onChange(of: vm.selection) { oldValue, newValue in resetEditMode() }
        .onChange(of: isTargeted) { oldValue, newValue in targetChanged(newValue) }
        .onDrop(of: [.text], isTargeted: $isTargeted, perform: onDropHandler)
    }
    
    /// We want to highlight the row if it is being dragged over. If it isn't, then we want to
    /// set the colour based on whether the current row is the selected row.
    fileprivate func listRowBackgroundColor() -> Color {
        if isTargeted { return Color.accentColor.opacity(0.5)}
        
        return node.id == vm.selection?.id
        ? Color.accentColor.opacity(0.2)
        : Color.clear
    }
    
    /// If the title text is being edited, then close edit mode.
    fileprivate func resetEditMode() {
        if titleEditEnabled {
            titleEditEnabled = false
        }
    }
    
    /// If the node becomes the target of a drag and drop move, we need to expand the
    /// children if the node has some, they are not expanded already and we have hovered
    /// over the node for 3/4 of a second.
    fileprivate func targetChanged(_ newValue: Bool) {
        if newValue == true
            && node.hasChildren
            && !node.isExpanded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                // Only do this if we are still the target of the drag operation.
                if isTargeted {
                    node.setExpansionState(to: .expanded)
                }
            }
        }
    }
    
    fileprivate func onDropHandler(providers: [NSItemProvider]) -> Bool {
        let targetNode = node
        if let sourceItem = providers.first {
            _ = sourceItem.loadObject(ofClass: String.self) { key, _ in
                // we have the key of the source node, go find it in the tree
                let sourceKey = UUID(uuidString: key!)!
                if let sourceNode = vm.tree?.findById(sourceKey) {
                    DispatchQueue.main.async {
                        vm.move(sourceNode, to: targetNode, inserting: .child)
                    }
                }
            }
        }
        
        return true
    }
}
