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
}
