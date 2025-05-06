//
//  MetadataServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol MetadataServiceType : ServiceBaseType {
    func getFileMetadataAsync(fileUrl: URL) async -> [MetadataType: Any?]
}
