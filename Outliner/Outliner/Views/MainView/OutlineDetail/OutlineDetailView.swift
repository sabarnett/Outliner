//
// File: DetailView.swift
// Package: Mac Template App
// Created by: Steven Barnett on 01/09/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineDetailView: View {
    
    @AppStorage(Constants.searchAppliesTo) var searchAppliesTo: SearchAppliesTo = .titleAndNotes
    @AppStorage(Constants.alternatingRows) private var alternatingRows: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var vm: MainViewModel
    
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
                        
                        ScrollViewReader { proxy in
                            List {
                                TreeNodeView(node: vm.tree!)
                                    .environmentObject(vm)
                            }
                            .alternatingRowBackgrounds(alternatingRows ? .enabled : .disabled)
                            .id(vm.listId)
                            .onReceive(AppNotifications.refreshOutline) { _ in
                                vm.listId = UUID()
                            }
                            .onChange(of: vm.scrollTo) {
                                if let scroll = vm.scrollTo {
                                    proxy.scrollTo(scroll)
                                    vm.scrollTo = nil
                                }
                            }
                        }
                        .toolbar { searchBar() }
                        .onChange(of: vm.searchFor) {
                            vm.performOutlineSearch(searchFor: vm.searchFor,
                                lookingIn: searchAppliesTo)
                        }
                    }.padding(.top, 50)
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    func searchBar() -> some View {
        SearchBar(text: $vm.searchFor)
            .frame(width: 360)
        
        if vm.searchResultCount > 0 {
            Text("\(vm.searchResultCount) matches")
                .font(.caption)
        }
        
        Button(action: {
            vm.searchMovePrevious()
        }, label: {
            Image(systemName: "chevron.left")
        })
        .padding(.horizontal, -8)
        .help("Find previous")
        .disabled(!vm.canSearchPrevious)
        
        Button(action: {
            vm.searchMoveNext()
        }, label: {
            Image(systemName: "chevron.right")
        })
        .padding(.leading, -8)
        .help("Find next")
        .disabled(!vm.canSearchNext)

    }
}

struct OutlineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OutlineDetailView(vm: MainViewModel())
    }
}
