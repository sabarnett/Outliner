//
// File: OutlineItemCheckBox.swift
// Package: Outline Tester
// Created by: Steven Barnett on 16/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import SwiftUI

struct OutlineItemCheckBox: View {
    
    @EnvironmentObject var vm: MainViewModel

    @ObservedObject var node: OutlineItem
    
    var body: some View {
        VStack(alignment: .trailing) {
            Image(systemName: node.completed ? "checkmark.square" : "square")
                .scaleEffect(1.1)
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
}

#Preview {
    OutlineItemCheckBox(node: OutlineItem.example)
}
