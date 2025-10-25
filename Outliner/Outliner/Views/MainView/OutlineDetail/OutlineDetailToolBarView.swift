//
// File: OutlineDetailToolBarView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 27/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineDetailToolbarItems: ToolbarContent {

    @ObservedObject var vm: MainViewModel

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .principal) {
            expandAllButton()
            collapseButton()
        }

        ToolbarItemGroup(placement: .principal) {
            addAboveButton()
            addBelowButton()
            addChildButton()
            duplicateItemButton()
            duplicateLegButton()
        }

        ToolbarItemGroup(placement: .principal) {
            indentButton()
            promoteButton()
        }

        ToolbarItemGroup(placement: .principal) {
            deleteItemButton()
        }
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

    // Group 2
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

    private func duplicateLegButton() -> some View {
        OutlineActionButton(
            imageName: "duplicate_leg",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Duplicate this item and it's children."
        ) {
            vm.duplicateLeg()
        }
        .disabled(vm.selection == nil)
    }

    private func duplicateItemButton() -> some View {
        OutlineActionButton(
            imageName: "duplicate_single",
            tint: vm.selection == nil ? Color.gray : Color("IconColor"),
            helpText: "Duplicate this item without it's children."
        ) {
            vm.duplicateItem()
        }
        .disabled(vm.selection == nil)
    }

    // Group 3
    private func indentButton() -> some View {
        OutlineActionButton(
            imageName: "tree_indent",
            tint: vm.canIndent() ? Color("IconColor") : Color.gray,
            helpText: "Move the item down a level."
        ) {
            vm.indentSelection()
        }
        .disabled(!vm.canIndent())
    }

    private func promoteButton() -> some View {
        OutlineActionButton(
            imageName: "tree_promote",
            tint: vm.canPromote() ? Color("IconColor") : Color.gray,
            helpText: "Move the item to the parent level."
        ) {
            vm.promoteSelection()
        }
        .disabled(!vm.canPromote())
    }

    // Group 4
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
