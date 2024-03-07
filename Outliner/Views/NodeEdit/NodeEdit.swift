//
// File: NodeEdit.swift
// Package: Outline Tester
// Created by: Steven Barnett on 11/02/2024
//
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct NodeEdit: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var vm: NodeEditViewModel
    
    var body: some View {
        VStack {
            Form {
                HStack {
                    Spacer()
                    ImageToggle(
                        caption: "Completed",
                        checkedImageName: "checkmark.square",
                        uncheckedImageName: "square",
                        value: $vm.completed
                    )
                    .help("Indicates whether the item has been completed.")
                    
                    ImageToggle(
                        caption: "Starred",
                        checkedImageName: "star.fill",
                        uncheckedImageName: "star",
                        value: $vm.starred
                    )
                    .help("Indicates whether the item has been flagged as important")
                }

                TextField("", text: $vm.text)
                    .themedFont(for: .nodeEditTitle)
                    .padding(.bottom)

                Section("Notes") {
                    TextEditor(text: $vm.notes)
                        .themedFont(for: .nodeEditNotes)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(nsColor: .tertiarySystemFill), lineWidth: 2))
                }
            }
            
            HStack {
                Spacer()
                Button("Save") {
                    vm.save()
                    dismiss()
                }
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .padding()
        .frame(width: 700, height: 600)
    }
}

struct ImageToggle: View {
    
    var caption: String
    var checkedImageName: String
    var uncheckedImageName: String
    
    @Binding var value: Bool
    
    public var body: some View {
        HStack {
            Image(systemName: value ? checkedImageName : uncheckedImageName)
                .resizable()
                .frame(width: 18, height: 18)
                .onTapGesture {
                    value.toggle()
                }
            
            Text(caption)
        }
    }
}

#Preview {
    NodeEdit(vm: NodeEditViewModel(node: nil) { node, action in
    })
}
