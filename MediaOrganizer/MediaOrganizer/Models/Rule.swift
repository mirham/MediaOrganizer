//
//  Rule.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class Rule : Codable, Identifiable, Equatable {
    var id = UUID()
    var number: Int = 0
    var conditions: [Condition] = [Condition]()
    var actions: [Action] = [Action]()
    var validation: Validation = Validation()
    var isEmpty: Bool {
        get {
            return conditions.isEmpty && actions.isEmpty
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case number
        case conditions
        case actions
    }
    
    func clone() -> Rule {
        let result = Rule()
        result.conditions = self.conditions.map({$0.clone()})
        result.actions = self.actions.map({$0.clone()})
        
        return result
    }
    
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.id == rhs.id
    }
}
