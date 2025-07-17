//
//  DuplicatesPolicy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.07.2025.
//

import Foundation

enum DuplicatesPolicy : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case keep = 480
    case overwrite = 481
    case skip = 482
    
    var description: String {
        switch self {
            case .keep: return "keep"
            case .overwrite: return "overwrite"
            case .skip: return "skip"
        }
    }
}
