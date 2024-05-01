//
// File: RecentFiles.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/12/2023
// 
// Copyright © 2023 Steven Barnett. All rights reserved.
//

import SwiftUI
import OutlinerViews

class OutlineManager: ObservableObject {
    
    private let MRUKey = "MRU"
    private let newFilePrefix = "New File"
    private var newFileIndex = 0
    
    @Published var recentFiles: [RecentFile] = []
    
    // MARK: - Initialisation
    
    /// Load recent files - this is saved to UserDefaults as an array of strings
    /// containing the full path to the file. We will not include any files that we
    /// cannot confirm still exist.
    init() {
        loadRecentFiles()
    }
    
    // MARK: - User API functions
    
    /// Clears the lis of recently opened files and clears the saved window positions and sizes.
    func clearHistory() {
        recentFiles = []
        saveRecentFilesList()
    }
    
    /// Removes the specified file from the recent files list
    ///
    /// - Parameter fileURL: The URL of the file to remove
    func removeFromRecents(_ fileURL: URL) {
        removeRecentFile(fileURL.path)
        saveRecentFilesList()
    }
    
    /// Create a new outline file and open an editor window. So we can identify this window when
    /// the user eventually saves the file, we use a representedFilename of "New File 00" where the
    /// "00" portion is an index that we maintain internally. This is _necessary_ to force a new window.
    /// If we did not do this, all windows would be created with the same name, so the same window
    /// would be reused (i.e. no new window would be opened after the first one).
    func createNew() {
        newFileIndex += 1
        
        MainView()
            .environmentObject(self)
            .frame(minWidth: 200, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .openInWindow(title: "New File", representedFile: "\(newFilePrefix) \(newFileIndex)", sender: self)
    }
    
    /// Opens an existing file at the specified URL.
    ///
    /// A check is made to ensure that the file exists. If we cannot find the file, a message is issued to the user and
    /// we return without doing anything. If we do find the file, a window is opened to process it.
    ///
    /// - Parameter fileURL: The URL of the file to be opened.
    /// 
    func openFile(at fileURL: URL) {
        var recentFile: RecentFile
        
        if FileManager().fileExists(atPath: fileURL.path) {
            recentFile = recentFiles.first(where: {$0.fileURL.path == fileURL.path })
                ?? RecentFile(file: fileURL)
            addToRecentFileList(recentFile)

            if let existingWindow = fileInWindow(fileName: fileURL.path) {
                existingWindow.orderFrontRegardless()
                existingWindow.makeKey()
            } else {
                let location: CGPoint = CGPoint(x: recentFile.locationX, y: recentFile.locationY)
                let size: CGSize = CGSize(width: recentFile.width, height: recentFile.height)
                
                MainView(outlineFile: fileURL)
                    .environmentObject(self)
                    .frame(minWidth: 200, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    .openInWindow(title: recentFile.fileName, representedFile: fileURL.path, sender: self,
                        atLocation: location, withSize: size)
            }
        } else {
            Alerts.fileDoesNotExist(filePath: fileURL)
            removeRecentFile(fileURL.path)
        }
    }
    
    /// Called to register that a file has been saved. It promotes the file up the MRU list to indicate
    /// that it was last accessed.
    ///
    /// We may, optionally, be passed a new file name if the file was saved with a new file name, or
    /// if the file was a new file and has just been named for the first time. If we have saved a file
    /// with a new name, we retain the old file name in the MRU and add the new name to the list (as
    /// both files will still exist).
    ///
    /// If this is a new file, we just add the new one to the top of the list.
    ///
    /// - Parameters:
    ///   - file: The file name and path of the current file
    ///   - as: The file name and path of the new file if this was a save-as.
    func saved(file: String, as newFile: String? = nil) {
        if let newFile, let newFileURL = URL(string: newFile) {
            addToRecentFileList(RecentFile(file: newFileURL))            
            fileInWindow(fileName: file)?.representedFilename = newFile
            
            return
        }
        
        if let oldFileUrl = URL(string: file) {
            let recentFile = RecentFile(file: oldFileUrl)
            addToRecentFileList(recentFile)
        }
    }
    
    /// File has been closed, so save the window size and position to the MRUlist.
    ///
    /// - Parameter file: The file that was closed
    func close(file: URL, previewOpen: Bool, previewWidth: CGFloat) {
        if let recentFile = recentFiles.first(where: {$0.fileURL.path == file.path }) {
            if let window = fileInWindow(fileName: recentFile.fileURL.path) {
                recentFile.setFrame(window.frame)
                recentFile.previewOpen = previewOpen
                recentFile.previewWidth = previewWidth
            }
            saveRecentFilesList()
        }
    }
    
    func recentFile(for file: URL?) -> RecentFile? {
        if let file {
            return recentFiles.first(where: {$0.fileURL.path == file.path })
        }
        return nil
    }
    // MARK: - Helper functions
    
    fileprivate func fileInWindow(fileName: String) -> NSWindow? {
        NSApplication.shared.windows.first(where: { $0.representedFilename == fileName})
    }
    
    fileprivate func addToRecentFileList(_ recentFile: RecentFile) {
        let file = recentFile
        
        removeRecentFile(file.fileURL.path)
        recentFiles.insert(file, at: 0)
        if let window = fileInWindow(fileName: file.fileURL.path) {
            file.setFrame(window.frame)
        }
        saveRecentFilesList()
    }
    
    fileprivate func saveRecentFilesList() {
        let recentFileNames = recentFiles.compactMap { recent in
            let encoder = JSONEncoder()
            return try? String(data: encoder.encode(recent), encoding: .utf8)
        }
        UserDefaults.standard.set(recentFileNames, forKey: MRUKey)
    }
    
    fileprivate func removeRecentFile(_ openedFilePath: String) {
        if let fileIndex = recentFiles.firstIndex(where: { file in file.fileURL.path == openedFilePath }) {
            recentFiles.remove(at: fileIndex)
        }
    }
    
    fileprivate func loadRecentFiles() {
        guard let mruFiles = UserDefaults.standard.stringArray(forKey: MRUKey)  else { return }

        let decoder = JSONDecoder()

        recentFiles = mruFiles.compactMap { options in
            let optionData = Data(options.utf8)
            
            if let mru = try? decoder.decode(RecentFile.self, from: optionData),
                FileManager().fileExists(atPath: mru.fileURL.path(percentEncoded: false)) {
                    return mru
            }
            return nil
        }
    }
}
