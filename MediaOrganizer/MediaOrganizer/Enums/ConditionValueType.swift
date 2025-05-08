//
//  ConditionValueType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.05.2025.
//

import Foundation

enum ConditionValueType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case string = 20
    case date = 21
    case int = 22
    case double = 23
}
