//
//  NumberAndDateOperatorType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.05.2025.
//

import Foundation

enum NumberAndDateOperatorType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case equals = 50
    case notEquals = 51
    case greater = 52
    case less = 53
    case greaterOrEquals = 54
    case lessOrEquals = 55
    
    var description: String {
        switch self {
            case .equals: return "="
            case .notEquals: return "≠"
            case .greater: return ">"
            case .less: return "<"
            case .greaterOrEquals: return ">="
            case .lessOrEquals: return "<="
        }
    }
}
