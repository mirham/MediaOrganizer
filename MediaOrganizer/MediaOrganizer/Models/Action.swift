//
//  Action.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class Action : Codable, Identifiable, Equatable {
    var id = UUID()
    var type = ActionType.rename
    
    func description() -> String {
        let result = type.description
        
        return result
    }
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
}
