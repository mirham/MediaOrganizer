//
//  MediaType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import Foundation

enum MediaType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case unknown = 0
    case photo = 1
    case video = 2
    
    var description: String {
        switch self {
            case .unknown: return "file"
            case .photo: return "photo"
            case .video: return "video"
        }
    }
}
