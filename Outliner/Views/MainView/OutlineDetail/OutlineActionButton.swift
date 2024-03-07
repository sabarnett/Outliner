//
// File: OutlineActionButton.swift
// Package: Outline Tester
// Created by: Steven Barnett on 27/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OutlineActionButton: View {
    
    let imageName: String
    let tint: Color
    let helpText: String?
    let action: (() -> Void)

    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center) {
                Image(imageName)
                    .renderingMode(.template)
                    .foregroundStyle(tint)
            }
        })
        .help(helpText ?? "")
    }
}
