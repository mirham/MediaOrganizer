//
//  UrlExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//


import Foundation
import UniformTypeIdentifiers

extension URL {
    var isImageFile: Bool {
        UTType(filenameExtension: pathExtension)?.conforms(to: .image) ?? false
    }
    
    var isVideoFile: Bool {
        UTType(filenameExtension: pathExtension)?.conforms (to: .movie)
        ?? UTType(filenameExtension: pathExtension)?.conforms (to: .video)
        ?? false
    }
}
