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
    
    static func == (lhs: Condition, rhs: Condition) -> Bool {
        return lhs.id == rhs.id
    }
}
