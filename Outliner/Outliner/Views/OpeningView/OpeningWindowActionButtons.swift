//
// File: OpeningWindowActionButtons.swift
// Package: Outline Tester
// Created by: Steven Barnett on 12/12/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OpeningWindowActionButtons: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var outlineManager: OutlineManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            openNewButton()
            Divider()
            openExistingButton()
            Divider()
            exitButton()
        }
        .padding(.bottom, 25)
    }
    
    func openNewButton() -> some View {
        VStack(alignment: .leading) {
            OpeningWindowButtonTextView(
                actionText: "Create a new file",
                description: "creates a new outline file with no content.",
                systemName: "book")

            .onTapGesture {
                outlineManager.createNew()
                dismiss()
            }
        }
    }
    
    func openExistingButton() -> some View {
        VStack(alignment: .leading) {
            OpeningWindowButtonTextView(
                actionText: "Open an existing file",
                description: "Browse for an existing outline file.",
                systemName: "book.fill")
            .onTapGesture {
                if let selectedFile = FileHelpers.selectSingleDataFile(withTitle: "Select an outline file") {
                    outlineManager.openFile(at: selectedFile)
                    dismiss()
                }
            }
        }
    }
    
    func exitButton() -> some View {
        VStack(alignment: .leading) {
            OpeningWindowButtonTextView(
                actionText: "Close the application",
                description: "Close the outliner without opening a file.",
                                        systemName: "book.closed.fill")
            .onTapGesture {
                NSApplication.shared.terminate(nil)
                dismiss()
            }
        }
    }
}

struct OpeningWindowButtonTextView: View {
    
    var actionText: String
    var description: String
    var systemName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.accentColor)
                VStack(alignment: .leading) {
                    Text(actionText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    Text(description)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

#Preview {
    OpeningWindowActionButtons()
}
