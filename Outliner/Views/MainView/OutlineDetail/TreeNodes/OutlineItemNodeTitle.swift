//
// File: OutlineItemNodeTitle.swift
// Package: Outline Tester
// Created by: Steven Barnett on 16/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct OutlineItemNodeTitle: View {
    
    @EnvironmentObject var vm: MainViewModel

    @ObservedObject var node: OutlineItem
    @Binding var titleEditEnabled: Bool
    
    var body: some View {
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
}

#Preview {
    OutlineItemNodeTitle(node: OutlineItem.example, titleEditEnabled: .constant(true))
}
