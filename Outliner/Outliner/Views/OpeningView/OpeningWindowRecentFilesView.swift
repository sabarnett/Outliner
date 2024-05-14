//
// File: OpeningWindowRecentFileView.swift
// Package: Outline Tester
// Created by: Steven Barnett on 12/12/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct OpeningWindowRecentFilesView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var outlineManager: OutlineManager
    
    @AppStorage(Constants.recentFileCount) var recentFileCount: Int = 5
    
    @State private var selectedItem: RecentFile?
    
    var recentFiles: [RecentFile] {
        Array(outlineManager.recentFiles.prefix(recentFileCount))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List(selection: $selectedItem) {
                ForEach(recentFiles, id: \.self) { file in
                    OpeningWindowRecentFileView(
                        recentFile: file.fileName,
                        recentFilePath: file.filePath
                    )
                    .help(file.fileURL.path)
                    .contentShape(Rectangle())
                    
                    // Double tap to open
                    .gesture(TapGesture(count: 2).onEnded {
                        outlineManager.openFile(at: file.fileURL)
                        dismiss()
                    })
                    
                    // Single tap to select
                    .simultaneousGesture(TapGesture().onEnded {
                        selectedItem = file
                    })
                    
                    .contextMenu {
                        Button("Remove From Recent Files List") {
                            outlineManager.removeFromRecents(file.fileURL)
                        }
                        Divider()
                        Button("Open Folder In Finder") {
                            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: file.filePath)
                        }
                    }
                }
                .listStyle(.plain)
            }
            HStack {
                Spacer()
                Button(action: {
                    outlineManager.clearHistory()
                }, label: {
                    Text("Clear History")
                }).buttonStyle(.plain)
            }
            .padding(12)
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .frame(width: 240)
        .task {
            if selectedItem == nil {
                selectedItem = outlineManager.recentFiles.first
            }
        }
    }
}

struct OpeningWindowRecentFileView: View {
    
    @State var recentFile: String = ""
    @State var recentFilePath: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recentFile)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(recentFilePath)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    OpeningWindowRecentFileView()
        .environmentObject(OutlineManager())
}
