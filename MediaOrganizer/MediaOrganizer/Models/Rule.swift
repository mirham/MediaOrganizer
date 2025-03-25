//
//  Rule.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class Rule : Codable, Identifiable, Equatable {
    var id = UUID()
    var conditions: [Condition] = [Condition]()
    var actions: [Action] = [Action]()
    
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.id == rhs.id
    }
    
    func apply(fileInfo: MediaFileInfo) -> [FileAction] {
        // TODO: Apply conditions here
        
        var result = [FileAction]()
        
        for action in actions {
            let fileAction = action.toFileAction(fileInfo: fileInfo)
            
            result.append(fileAction)
        }
        
        return result
    }
}
