//
// File: ContentView.swift
// Package: Outliner
// Created by: Steven Barnett on 13/08/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerViews

struct MainView: View {
    
    @EnvironmentObject var outlineManager: OutlineManager
    
    @StateObject var vm: MainViewModel = MainViewModel()
    @State var outlineFile: URL?
    
    @State private var detailViewStyle: DetailViewType = .outline
    @State private var columnsVisible = NavigationSplitViewVisibility.all
    @State private var noteSplitterValue: CGFloat = 0.7
    @State private var hiddenNotePane = SideHolder()
    
    var body: some View {
        ZStack {
            HostingWindowFinder { window in
                if let window = window {
                    vm.windowNumber = window.windowNumber
                    window.setFrameAutosaveName("")
                }
            }.frame(width: 0, height: 0)
            
            NavigationSplitView(
                columnVisibility: $columnsVisible,
                sidebar: {
                    SidebarView(vm: vm, detailView: $detailViewStyle)
                        .frame(minWidth: Constants.mainWindowSidebarMinWidth)
                },
                detail: {
                    Split(primary: {
                        detailView()
                    }, secondary: {
                        notePreviewView()
                    }
                    )
                    .hide(hiddenNotePane)
                    .fraction(noteSplitterValue)
                    .constraints(minPFraction: 0.25, minSFraction: 0.1)
                    .splitter(Splitter.invisible)
                    .styling(invisibleThickness: 8)
                    .onDrag({ newFraction in
                        noteSplitterValue = newFraction
                    })
                })
            .frame(minWidth: Constants.mainWindowMinWidth,
                   minHeight: Constants.mainWindowMinHeight)
            .focusedSceneObject(vm)
            
            .sheet(item: $vm.viewNote) { node in
                NoteView(vm: node)
            }
            
            .sheet(item: $vm.editItem) { editNode in
                NodeEdit(vm: editNode)
            }
            
            .sheet(isPresented: $vm.showexport) {
                Export(vm: vm)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button(action: {
                        withAnimation {
                            columnsVisible = columnsVisible == .all ? .detailOnly : .all
                        }
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
                
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        withAnimation {
                            hiddenNotePane.toggle()
                        }
                    }, label: {
                        Image(systemName: "sidebar.right")
                    })
                }
            }
            
            .onReceive(SysNotifications.willClose, perform: windowClosing)
            .onReceive(SysNotifications.willTerminate, perform: appTerminating)
            
            .onAppear {
                if let recentFile = outlineManager.recentFile(for: outlineFile) {
                    hiddenNotePane.side = recentFile.previewOpen
                    ? SplitSide(rawValue: "secondary")
                    : nil
                    noteSplitterValue = recentFile.previewWidth
                }
            }
            .task {
                vm.load(outline: outlineFile)
            }
            .navigationTitle(vm.windowTitle)
        }
    }
    
    /// A window is closing, which may, or may not, be ours. If it's ours, we
    /// need to prompt the user to save their changes if any have been made.
    ///
    /// - Parameter value: The notification parameters from the notification centre
    func windowClosing(value: NotificationCenter.Publisher.Output) {
        guard let win = value.object as? NSWindow,
              win.windowNumber == vm.windowNumber else { return }
        
        promptForSave()
        saveWindow()
    }
    
    func appTerminating(value: NotificationCenter.Publisher.Output) {
        promptForSave()
        saveWindow()
    }
    
    @ViewBuilder func detailView() -> some View {
        if detailViewStyle == .outline {
            OutlineDetailView(vm: vm)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ListDetailView(vm: vm, detailViewStyle: detailViewStyle)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder func notePreviewView() -> some View {
        if let selection = vm.selection {
            NoteViewPreview(vm: NodeViewViewModel(node: selection, highlightText: vm.searchFor))
                .padding(.bottom, 12)
        } else {
            ContentUnavailableView("Nothing Selected",
                                   systemImage: "doc.circle",
                                   description: Text("Please select an item in the tree to view it's notes"))
        }
    }
    
    /// Optionally save the file if it has changed
    func promptForSave() {
        if vm.requiresSave && Alerts.saveChangesPrompt() == .save {
            vm.save()
        }
        
        vm.reset()
    }
    
    /// Save the current state of the window so we can restore it next time this file is opened.
    func saveWindow() {
        if let outlineFile {
            outlineManager.close(file: outlineFile,
                                 previewOpen: hiddenNotePane.side != nil,
                                 previewWidth: noteSplitterValue)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
