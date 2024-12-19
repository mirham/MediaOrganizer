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
    let originalUrl: URL
    var currentUrl: URL
    
    init(type: MediaType, url: URL, metadata: [MetadataType: Any?]) {
        self.type = type
        self.originalUrl = url
        self.currentUrl = url
        self.metadata = metadata
    }
    
    static func == (lhs: MediaFileInfo, rhs: MediaFileInfo) -> Bool {
        return lhs.id == rhs.id
    }
}
