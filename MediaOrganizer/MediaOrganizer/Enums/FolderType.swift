//
//  FolderType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

enum FolderType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case source = 0
    case destination = 1
    
    var description: String {
        switch self {
            case .source: return "source"
            case .destination: return "destination"
        }
    }
}
