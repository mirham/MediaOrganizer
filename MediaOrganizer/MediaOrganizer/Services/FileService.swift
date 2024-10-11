//
//  FileService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import Foundation
import Combine

class FileService : ServiceBase {
    static let shared = FileService()
    
    private let metadataService = MetadataService.shared
    
    func getFolderFilesAsync(path: String) async -> [MediaInfo] {
        var result = [MediaInfo]()
        let path = URL( string: path)
        
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
        
        let filteredFileUrls = await listFilesInFolderAsync(at: path!, options: options).filter {
            $0.isImageFile || $0.isVideoFile
        }
        
        for await fileUrl in filteredFileUrls {
            let mediaType = fileUrl.isImageFile ? MediaType.photo : MediaType.video
            let metadata = await metadataService.getFileMetadataAsync(fileUrl: fileUrl)
            let mediaInfo = MediaInfo(type: mediaType, url: fileUrl, metadata: metadata)
            
            result.append(mediaInfo)
        }
        
        return result
    }
    
    
    // MARK: Private functions
    
    func listFilesInFolderAsync(at url: URL, options: FileManager.DirectoryEnumerationOptions ) async -> AsyncStream<URL> {
        AsyncStream { continuation in
            Task {
                let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil, options: options)
                
                while let fileURL = enumerator?.nextObject() as? URL {
                    if fileURL.hasDirectoryPath {
                        for await item in await listFilesInFolderAsync(at: fileURL, options: options) {
                            continuation.yield(item)
                        }
                    } else {
                        continuation.yield( fileURL )
                    }
                }
                continuation.finish()
            }
        }
    }
}
