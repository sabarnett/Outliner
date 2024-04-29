//
// File: SidebarViewTypeButton.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

struct SidebarViewTypeButton: View {
    
    var viewType: DetailViewType
    @Binding var selection: DetailViewType
    var count: Int = 0
    
    var body: some View {
        HStack {
            Image(viewType.toolbarImage)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24, height: 24)
            Text(viewType.description)
                .themedFont(for: .sidebarButton)
            Spacer()
            if count > 0 {
                Text("\(count)")
                    .themedFont(for: .sidebarCounter)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(2)
        .contentShape(Rectangle())
        .onTapGesture {
            selection = viewType
        }
        .listRowBackground(viewType == selection
                           ? Color.accentColor.opacity(0.4)
                           : Color(nsColor: .windowBackgroundColor))
        .listRowSeparator(.hidden)
    }
}
