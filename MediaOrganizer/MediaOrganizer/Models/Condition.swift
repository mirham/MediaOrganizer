//
//  Condition.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.09.2024.
//

import Foundation

class Condition : Codable, Identifiable, Equatable {
    var id = UUID()
    var type = ConditionType.cIf
    var elements: [ConditionElement] = [ConditionElement]()
    
    func description() -> String {
        let result = type.description
        
        return result
    }
    
    func clone() -> Condition {
        let result = Condition()
        result.type = self.type
        result.elements = self.elements.map({$0.clone(withValue: true) as! ConditionElement})
        
        return result
    }
    
    func isEmpty() -> Bool {
        return elements.isEmpty
    }
    
    static func == (lhs: Condition, rhs: Condition) -> Bool {
        return lhs.id == rhs.id
    }
}
