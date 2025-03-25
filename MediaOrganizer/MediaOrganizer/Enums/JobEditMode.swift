//
//  JobEditMode.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

enum JobEditMode : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case add = 0
    case edit = 1
    
    var description: String {
        switch self {
            case .add: return "add"
            case .edit: return "edit"
        }
    }
}
