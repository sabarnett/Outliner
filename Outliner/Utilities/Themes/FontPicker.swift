//
// File: FontPicker.swift
// Package: Outline Tester
// Created by: Steven Barnett on 04/03/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct FontPicker: View {
    
    @Binding var fontFamily: String
    @Binding var fontSize: Int
    @Binding var fontWeight: ThemeFontWeight
    
    var fontFamilies: [String] {
        NSFontManager.shared.availableFontFamilies
    }
    var fontSizes: [Int] {
        Array(7..<40)
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $fontFamily) {
                    Text("Default")
                        .tag("Default")
                    ForEach(fontFamilies, id: \.self) { family in
                        Text(family)
                            .tag(family)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 200)
                
                Picker("", selection: $fontSize) {
                    ForEach(fontSizes, id: \.self) { size in
                        Text("\(size)")
                            .tag(size)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 70)

                Picker("", selection: $fontWeight) {
                    ForEach(ThemeFontWeight.allCases) { weight in
                        Text(weight.description)
                            .tag(weight)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: 110)
            }
            .onChange(of: fontFamily) { olld, new in
                print(fontFamily)
            }
        }
    }
}

#Preview {
    FontPicker(fontFamily: .constant("Default"), fontSize: .constant(14), fontWeight: .constant(.regular))
}
