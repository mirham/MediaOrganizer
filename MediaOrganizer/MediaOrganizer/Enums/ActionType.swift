//
//  ActionType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

enum ActionType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case rename = 0
    case copyToFolder = 1
    case moveToFolder = 2
    case delete = 3
    
    var description: String {
        switch self {
            case .rename: return "rename"
            case .copyToFolder: return "copy to folder"
            case .moveToFolder: return "move to folder"
            case .delete: return "delete"
        }
    }
}
