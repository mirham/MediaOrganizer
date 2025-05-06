//
//  FileServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol FileServiceType {
    func getFolderMediaFilesAsync(path: String) async -> [MediaFileInfo]
    func peformFileActionsAsync(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileActions: [FileAction]) async
}
