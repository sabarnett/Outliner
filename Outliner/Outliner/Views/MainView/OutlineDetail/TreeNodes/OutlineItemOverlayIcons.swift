//
// File: OutlineItemOverlayIcons.swift
// Package: Outline Tester
// Created by: Steven Barnett on 07/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerFile

struct OutlineItemOverlayIcons: View {
    
    @EnvironmentObject var vm: MainViewModel
    @ObservedObject var node: OutlineItem
    
    var body: some View {
        HStack {
            Spacer()
            
            Image(systemName: node.starred ? "star.fill" : "star")
                .scaleEffect(1.4)
                .foregroundStyle( node.starred ? Color.accentColor : Color.secondary)
                .opacity(0.8)
                .onTapGesture {
                    node.starred.toggle()
                    vm.starredCount += node.starred ? 1 : -1
                }
            Image(systemName: node.notes.isEmpty ? "doc" : "doc.text")
                .scaleEffect(1.4)
                .foregroundStyle( node.notes.isEmpty ? Color.secondary : Color.accentColor)
                .opacity(0.8)
                .onTapGesture {
                    if !node.notes.isEmpty {
                        vm.showNote(node)
                    }
                }
            Image(systemName: "square.and.pencil")
                .scaleEffect(1.4)
                .foregroundStyle(.primary.opacity(0.8))
                .onTapGesture {
                    vm.editNode(node)
                }
        }
    }
}
