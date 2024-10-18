//
//  Action.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class Action : Codable, Identifiable, Equatable, ObservableObject {
    var id = UUID()
    var type = ActionType.rename
    var elements: [Element] = [Element]()
    
    func description() -> String {
        let result = type.description
        
        return result
    }
    
    func toFileAction(fileInfo: MediaFileInfo) -> FileAction {
        var value: String? = nil
        
        for element in elements {
            //element.
        }
        
        return FileAction(actionType: type, value: value)
    }
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
}
