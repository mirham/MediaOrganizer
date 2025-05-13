//
//  ConditionType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

enum ConditionType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case cIf = 100
    case cElseIf = 101
    
    var description: String {
        switch self {
            case .cIf: return "if"
            case .cElseIf: return "else if"
        }
    }
}
