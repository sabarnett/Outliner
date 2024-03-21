//
// File: ContentView.swift
// Package: Outliner
// Created by: Steven Barnett on 13/08/2023
//
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.openWindow) private var openWindow
    @EnvironmentObject var outlineManager: OutlineManager
    
    @StateObject var vm: MainViewModel = MainViewModel()
    @State var outlineFile: URL?
    @State var windowNumber: Int = 0
    @State var detailViewStyle: DetailViewType = .outline
    @State private var columnsVisible = NavigationSplitViewVisibility.all
    
    @State private var splitValue: CGFloat = 0.7
    @State private var hide = SideHolder()
    
    @State private var hasInspectorAppeared: Bool = false
    
    var body: some View {
        ZStack {
            HostingWindowFinder { window in
                if let window = window {
                    windowNumber = window.windowNumber
                    window.setFrameAutosaveName("")
                }
            }.frame(width: 0, height: 0)
            
            NavigationSplitView(columnVisibility: $columnsVisible,
                                sidebar: {
                SidebarView(vm: vm, detailView: $detailViewStyle)
                    .frame(minWidth: Constants.mainWindowSidebarMinWidth)
            }, detail: {
                
                Split(primary: {
                    detailView()
                }, secondary: {
                    notePreviewView()
                })
                .hide(hide)
                .fraction(splitValue)
                .constraints(minPFraction: 0.25, minSFraction: 0.1)
                .styling(visibleThickness: 3, invisibleThickness: 5)
                .onDrag({ newFraction in
                    splitValue = newFraction
                    print("New splitter fraction: \(newFraction)")
                })
                
//                
//                detailView()
//                    .inspector(isPresented: $vm.showInspector) {
//                        notePreviewView()
//                            .inspectorColumnWidth(min: 200, ideal: vm.inspectorWidth, max: 750)
//                            .interactiveDismissDisabled()
//                            .frame(minWidth: hasInspectorAppeared ? nil : vm.inspectorWidth)
//                            .onAppear {
//                                // ONLY HAPPENS ONCE, SO TOGGLING THE VISIBLE NEVER RESETS THE HAS APPEARED VALUE
//                                hasInspectorAppeared = true
//                            }
//                    }
//                    .onChange(of: vm.showInspector) {
//                        if vm.showInspector { hasInspectorAppeared = true }
//                    }
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
            
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button(action: {
                        columnsVisible = columnsVisible == .all ? .detailOnly : .all
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
                
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        withAnimation {
                            hide.toggle()
                        }
                    }, label: {
                        Image(systemName: "sidebar.right")
                    })
                }
            }
            
            .onReceive(SysNotifications.willClose, perform: windowClosing)
            .onReceive(SysNotifications.willTerminate, perform: appTerminating)
            
            .task {
                if let recentFile = outlineManager.recentFile(for: outlineFile) {
                    vm.showInspector = recentFile.previewOpen
                    vm.inspectorWidth = recentFile.previewWidth
                }
                vm.load(outline: outlineFile)
            }
            .navigationTitle(vm.windowTitle)
        }
    }
    
    /// A window is closing, which may, or may not, be ours. If it's ours, we
    /// need to prompt the usrer t save their changes if any have been made.
    ///
    /// - Parameter value: The notification parameters from the notification centre
    func windowClosing(value: NotificationCenter.Publisher.Output) {
        guard let win = value.object as? NSWindow,
              win.windowNumber == windowNumber else { return }
        
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
            NoteViewPreview(vm: NodeViewViewModel(node: selection))
                .padding(.bottom, 12)
        } else {
            ContentUnavailableView("Nothing Selected",
                                   systemImage: "doc.circle",
                                   description: Text("Please select an item in the tree to view it's notes"))
        }
    }
    
    func promptForSave() {
        if vm.requiresSave && Alerts.saveChangesPrompt() == .save {
            vm.save()
        }
        
        vm.reset()
    }
    
    func saveWindow() {
        if let outlineFile {
            outlineManager.close(file: outlineFile,
                                 previewOpen: vm.showInspector,
                                 previewWidth: vm.inspectorWidth)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
