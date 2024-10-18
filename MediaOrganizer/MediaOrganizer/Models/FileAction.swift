//
//  FileAction.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.10.2024.
//

import Foundation

class FileAction : Identifiable {
    var id = UUID()
    let actionType: ActionType
    let value: String?
    
    init(actionType: ActionType, value: String?) {
        self.actionType = actionType
        self.value = value
    }
}
