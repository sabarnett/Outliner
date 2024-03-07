//
// File: OutlineDetailToolBarView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 27/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineDetailToolBarView: View {
    
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            expandAllButton()
                .padding(.trailing, -10)
            collapseButton()

            Spacer().frame(width: 22)
            
            addAboveButton()
                .padding(.trailing, -10)
            addBelowButton()
                .padding(.trailing, -10)
            addChildButton()
            
            Spacer().frame(width: 22)
            
            deleteItemButton()
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity)
    }
    
    private func expandAllButton() -> some View {
        OutlineActionButton(
            imageName: "tree_expand_all",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Expand all items below the currently selected one."
        ) {
            vm.expandSelectedItem()
        }
        .disabled(vm.selection == nil)
    }
    
    private func collapseButton() -> some View {
        OutlineActionButton(
            imageName: "tree_collapse",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Collapse the currently selected items children."
        ) {
            vm.collapseSelectedItem()
        }
        .disabled(vm.selection == nil)
    }
    
    private func addAboveButton() -> some View {
        OutlineActionButton(
            imageName: "tree_add_above",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Add a new item above the current one."
        ) {
            vm.addAbove()
        }
        .disabled(vm.selection == nil)
    }
    
    private func addBelowButton() -> some View {
        OutlineActionButton(
            imageName: "tree_add_below",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Add a new item below the current one."
        ) {
            vm.addBelow()
        }
        .disabled(vm.selection == nil)
    }
    
    private func addChildButton() -> some View {
        OutlineActionButton(
            imageName: "tree_add_child",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Add a new item at the next level down."
        ) {
            vm.addChild()
        }
        .disabled(vm.selection == nil)
    }
    
    private func deleteItemButton() -> some View {
        OutlineActionButton(
            imageName: "tree_delete",
            tint: vm.selection == nil ? Color.gray : .red,
            helpText: "Delete the current item and it's children."
        ) {
                vm.deleteSelectedItem()
        }
        .disabled(vm.selection == nil)
    }
}

#Preview {
    OutlineDetailToolBarView(vm: MainViewModel())
}
