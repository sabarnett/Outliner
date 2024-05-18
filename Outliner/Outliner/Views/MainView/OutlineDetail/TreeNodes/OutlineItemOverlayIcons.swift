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
            
            OutlineItemOverlayIcon(imageName: node.starred ? "star.fill" : "star", 
                                   highlighted: node.starred) {
                node.starred.toggle()
                vm.starredCount += node.starred ? 1 : -1
            }
            OutlineItemOverlayIcon(imageName: node.notes.isEmpty ? "doc" : "doc.text", 
                                   highlighted: node.notes.isEmpty) {
                if !node.notes.isEmpty {
                    vm.showNote(node)
                }
            }
            OutlineItemOverlayIcon(imageName: "square.and.pencil",
                                   highlighted: true) {
                    vm.editNode(node)
                }
        }
    }
}

struct OutlineItemOverlayIcon: View {
    let imageName: String
    let highlighted: Bool
    let onTapped: () -> Void
    
    var body: some View {
        Image(systemName: imageName)
            .scaleEffect(1.4)
            .foregroundStyle( highlighted ? Color.accentColor : Color.secondary)
            .opacity(0.8)
            .onTapGesture(perform: onTapped)
    }
}
