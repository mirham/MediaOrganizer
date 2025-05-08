//
//  StringOperatorType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.05.2025.
//

import Foundation

enum StringOperatorType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case equals = 70
    case contains = 71
    case notContains = 72
    case startsWith = 73
    case endsWith = 74
    case oIn = 75
    
    var description: String {
        switch self {
            case .equals: return "is"
            case .contains: return "contains"
            case .notContains: return "not contains"
            case .startsWith: return "starts with"
            case .endsWith: return "ends with"
            case .oIn: return "in"
        }
    }
}
