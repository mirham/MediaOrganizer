//
//  MediaFileInfo.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import Foundation

class MediaFileInfo : Identifiable, Equatable {
    let id = UUID()
    let type: MediaType
    let metadata: [MetadataType: Any?]
    var url: URL
    
    init(type: MediaType, url: URL, metadata: [MetadataType: Any?]) {
        self.type = type
        self.url = url
        self.metadata = metadata
    }
    
    static func == (lhs: MediaFileInfo, rhs: MediaFileInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
