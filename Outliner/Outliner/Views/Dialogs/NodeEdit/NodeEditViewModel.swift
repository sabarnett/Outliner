//
// File: NodeEditViewModel.swift
// Package: Outline Tester
// Created by: Steven Barnett on 13/02/2024
// 
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation
import OutlinerFile

class NodeEditViewModel: ObservableObject, Identifiable {
    
    var id: UUID = UUID()
    var node: OutlineItem?
    var editAction: EditAction
    var onSave: ((OutlineItem, EditAction) -> Void)
    
    @Published var text: String = ""
    @Published var notes: String = ""
    @Published var completed: Bool = false
    @Published var starred: Bool = false
    
    init(
        node: OutlineItem? = nil,
        editActtion: EditAction = .editExisting,
        onSave: @escaping ((OutlineItem, EditAction) -> Void)
    ) {
        self.editAction = editActtion

        self.node = node
        self.text = node?.text ?? ""
        self.notes = node?.notes ?? ""
        self.completed = node?.completed ?? false
        self.starred = node?.starred ?? false
        
        self.onSave = onSave
    }
    
    func save() {
        if node == nil {
            node = OutlineItem()
        }
        
        node?.text = text
        node?.notes = notes
        node?.completed = completed
        node?.starred = starred
        
        onSave(node!, editAction)
    }
}
