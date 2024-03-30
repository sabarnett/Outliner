//
// File: ContextMenuItems.swift
// Package: Outline Tester
// Created by: Steven Barnett on 30/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ContextMenuItems: View {
    
    @EnvironmentObject var vm: MainViewModel
    
    var node: OutlineItem
    
    var body: some View {
        Group {
            Text(node.text).font(.title2)
            Divider()
            
            insertMenu
            duplicateMenu
            moveMenu
            
            Divider()
            sortMenu
            
            Divider()
            deleteMenu
        }
    }
    
    private var insertMenu: some View {
        Menu(content: {
            Button("Add Item Above") {
                vm.selection = node
                vm.addAbove()
            }
            
            Button("Add Item Below") {
                vm.selection = node
                vm.addBelow()
            }
            
            Button("Add Child Item") {
                vm.selection = node
                vm.addChild()
            }
        }, label: { Text("Insert") })
    }
    
    private var duplicateMenu: some View {
        Menu(content: {
            Button("Current Item") {
                vm.selection = node
                vm.duplicateItem()
            }
            
            Button("Current Item And Children") {
                vm.selection = node
                vm.duplicateLeg()
            }
        }, label: { Text("Duplicate")})
    }
    
    private var moveMenu: some View {
        Menu(content: {
            Button("Move Item Down One Level") {
                vm.selection = node
                vm.indentSelection() }
            .disabled(!(vm.canIndent(item: node)))
            
            Button("Move Item Up One Level") {
                vm.selection = node
                vm.promoteSelection() }
            .disabled(!(vm.canPromote(item: node)))
        }, label: { Text("Move")})
    }
    
    private var sortMenu: some View {
        Menu(content: {
            Button("By Name") {
                vm.selection = node
                //                vm.indentSelection()
            }
            
            Button("By Starred") {
                vm.selection = node
                //                vm.indentSelection()
            }
            
            Button("By Creation Date") {
                vm.selection = node
                //                vm.promoteSelection()
            }
            
            Button("By Updated Date") {
                vm.selection = node
                //                    vm.promoteSelection()
            }
            
            Button("By Completion Date") {
                vm.selection = node
                //                    vm.promoteSelection()
            }
        }, label: { Text("Sort Level")})
    }
    
    private var deleteMenu: some View {
        Button("Delete Item") {
            vm.selection = node
            vm.deleteSelectedItem()
        }
    }
}
