//
// File: SidebarViewTypeHeading.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import SwiftUI

struct SidebarViewTypeHeading: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @State var heading: String
    
    var body: some View {
        Text(heading)
            .themedFont(for: .sidebarHeading)
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .background(colorScheme == .dark ? .black : .white)
    }
}
