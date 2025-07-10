//
//  Action.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class Action : Codable, Identifiable, Equatable, ObservableObject {
    var id = UUID()
    var type = ActionType.skip
    var elements: [ActionElement] = [ActionElement]()
    
    func description() -> String {
        let result = type.description
        
        return result
    }
    
    static func == (lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
    
    func clone() -> Action {
        let result = Action()
        result.type = self.type
        result.elements = self.elements.map({$0.clone(withValue: true) as! ActionElement})
        
        return result
    }
}
