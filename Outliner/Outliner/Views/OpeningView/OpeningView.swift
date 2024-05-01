//
// File: OpeningView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 11/12/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerViews

struct OpeningView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(alignment: .top) {
            OpeningWindowButtonsView()
            
            OpeningWindowRecentFilesView()
            
            HostingWindowFinder { window in
                setWindowStyles(window)
            }.frame(height: 0)
        }
        .frame(width: 680, height: 420)
        .presentedWindowStyle(.hiddenTitleBar)
        .overlay(alignment: .topLeading) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray.opacity(0.5))
                    .scaleEffect(1.3)
            })
            .buttonStyle(.plain)
            .padding(.leading, 8)
            // Fudge - move the icon to the titlebar area
            .padding(.top, -15)
        }
    }
    
    private func setWindowStyles(_ window: NSWindow?) {
        if let window = window {
            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
            window.isMovableByWindowBackground = true
        }
    }
}

#Preview {
    OpeningView()
        .environmentObject(OutlineManager())
}
