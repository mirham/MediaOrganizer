//
//  OptionalElementType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 30.09.2024.
//

import Foundation

enum OptionalElementType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case slash = 1000
    case customText = 1001
    case customDate = 1002
    
    var description: String {
        switch self {
            case .slash: return "/"
            case .customText: return "custom text"
            case .customDate: return "custom date"
        }
    }
}
