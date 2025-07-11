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
    var isValid: Bool = true
    var validationMessage: String? = nil
    var isEmpty: Bool {
        get {
            return conditions.isEmpty && actions.isEmpty
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case conditions
        case actions
    }
    
    static func == (lhs: Rule, rhs: Rule) -> Bool {
        return lhs.id == rhs.id
    }
}
