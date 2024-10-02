//
//  ElementType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 30.09.2024.
//

import Foundation

enum ElementType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case slash = 0
    case customText = 1
    case customDate = 2
    
    var description: String {
        switch self {
            case .slash: return "/"
            case .customText: return "custom text"
            case .customDate: return "custom date"
        }
    }
}
