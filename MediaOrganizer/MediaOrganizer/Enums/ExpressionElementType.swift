//
//  ExpressionElementType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 09.05.2025.
//

import Foundation

enum ExpressionElementType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case and = 1100
    case or = 1101
    case leftParen = 1102
    case rightParen = 1103
    
    var description: String {
        switch self {
            case .and: return "AND"
            case .or: return "OR"
            case .leftParen: return "("
            case .rightParen: return ")"
        }
    }
}
