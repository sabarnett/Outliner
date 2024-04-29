//
// File: OpeningWindowButtonsView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 20/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OpeningWindowButtonsView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack {
            OpeningWindowLogoView()
            Spacer()
            OpeningWindowActionButtons()
        }
        .frame(width: 440)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

#Preview {
    OpeningWindowButtonsView()
}
