//
// File: SidebarView.swift
// Package: Mac Template App
// Created by: Steven Barnett on 01/09/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct SidebarView: View {

    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var vm: MainViewModel
    
    @Binding var detailView: DetailViewType
    @State private var listId: UUID = UUID()

    var body: some View {
//        VStack(alignment: .leading) {
            List {
                Section(content: {
                    SidebarViewTypeButton(viewType: .outline,
                                          selection: $detailView,
                                          count: vm.nodeCount)
                }, header: {
                    SidebarViewTypeHeading(heading: "Outline")
                })
                Section(content: {
                    SidebarViewTypeButton(viewType: .completed,
                                          selection: $detailView,
                                          count: vm.completeCount)
                        
                    SidebarViewTypeButton(viewType: .incomplete,
                                          selection: $detailView,
                                          count: vm.incompleteCount)

                    SidebarViewTypeButton(viewType: .starred,
                                          selection: $detailView,
                                          count: vm.starredCount)
                }, header: {
                    SidebarViewTypeHeading(heading: "Views")
                })
                Section(content: {
                    SidebarViewTypeButton(viewType: .recentlyAdded,
                                          selection: $detailView)
                    SidebarViewTypeButton(viewType: .recentlyCompleted,
                                          selection: $detailView)
                    SidebarViewTypeButton(viewType: .recentlyUpdated,
                                          selection: $detailView)
                }, header: {
                    SidebarViewTypeHeading(heading: "Recent")
                })
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .listRowInsets(.none)
            .id(listId)
            .onReceive(AppNotifications.refreshSidebar) { _ in
                listId = UUID()
            }
        }
//    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(vm: MainViewModel(), detailView: .constant(.outline))
    }
}
