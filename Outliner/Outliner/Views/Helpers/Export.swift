//
// File: Export.swift
// Package: Outliner
// Created by: Steven Barnett on 08/06/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//
        
import OutlinerFile
import SwiftUI

struct Export: View {
    
    @Environment(\.dismiss) var dismiss
    
    var vm: MainViewModel
    
    @State var exportFormat: ExportFormat = .html
    @State var exportContent: ExportContent = .single
    
    var body: some View {
        if let selection = vm.selection {
            Form {
                LabeledContent("Export what", value: selection.text)
                
                Picker("Format", selection: $exportFormat, content: {
                    ForEach(ExportFormat.allCases) { format in
                        Text(format.description).tag(format)
                    }
                })
                
                Picker("Export", selection: $exportContent, content: {
                    ForEach(ExportContent.allCases) { content in
                        Text(content.description).tag(content)
                    }
                })
                
            }.padding()
        } else {
            ContentUnavailableView("Nothing To Export",
                                   image: "circle.slash",
                                   description: Text("There is no selected item to export"))
        }
        HStack {
            Spacer()
            Button("Cancel", role: .cancel, action: {
                dismiss()
            })
            
            Button("Export", role: .none, action: {
                exportData()
                dismiss()
            }).keyboardShortcut(.defaultAction)
                
        }.padding(16)
    }
    
    func exportData() {
        Exporter().export(
            treeFile: vm.treeFile,
            selection: vm.selection!,
            exportFormat: exportFormat,
            exportContent: exportContent
        )
    }
}

#Preview {
    Export(vm: MainViewModel())
}
