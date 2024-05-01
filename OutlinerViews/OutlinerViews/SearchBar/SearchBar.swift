//
// File: SearchBar.swift
// Package: Outline Tester
// Created by: Steven Barnett on 08/04/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct SearchBar: View {
    @Binding var text: String
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        HStack {
            
            TextField("Search For", text: $text)
                .padding(.vertical, 7)
                .padding(.leading, 32)
                .cornerRadius(8)
                .textFieldStyle(.roundedBorder)
            
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        Button(action: {
                            self.text = ""
                            let window = NSApplication.shared.windows.first!
                            window.makeFirstResponder(nil)
                        }, label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.trailing, 0)
                        })
                    }
                )
            
                .padding(.horizontal, 8)
        }
    }
}

#Preview {
    SearchBar(text: .constant(""))
}
