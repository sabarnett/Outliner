//
// File: DetailView.swift
// Package: Mac Template App
// Created by: Steven Barnett on 01/09/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineDetailView: View {
    
    @AppStorage(Constants.alternatingRows) private var alternatingRows: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var vm: MainViewModel
    @State private var listId: UUID = UUID()
    
    var body: some View {
        VStack(alignment: .leading) {
            if vm.isLoading {
                ContentUnavailableView("Loading",
                                       systemImage: "square.split.bottomrightquarter.fill",
                                       description: Text("Loading the selected outline."))
            } else {
                HSplitView(content: {
                    VStack {
                        OutlineDetailToolBarView(vm: vm)
                        List {
                            TreeNodeView(node: vm.tree!)
                                .environmentObject(vm)
                        }

                        .alternatingRowBackgrounds(alternatingRows ? .enabled : .disabled)
                        .id(listId)
                        .onReceive(AppNotifications.refreshOutline) { _ in
                            listId = UUID()
                        }
                    }
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
}

struct OutlineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OutlineDetailView(vm: MainViewModel())
    }
}
