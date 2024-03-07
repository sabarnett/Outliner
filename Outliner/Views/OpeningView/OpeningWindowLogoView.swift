//
// File: OpeningWindowLogoView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 20/01/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OpeningWindowLogoView: View {
    var body: some View {
        VStack {
            Image(.appLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 130)
                .padding(.top, 10)

            Text("\(Bundle.main.appName)")
                .font(.system(size: 26, weight: .bold))
                .textSelection(.enabled)

            Text("Version \(Bundle.main.appVersionFull)")
                .textSelection(.enabled)
        }

    }
}

#Preview {
    OpeningWindowLogoView()
}
