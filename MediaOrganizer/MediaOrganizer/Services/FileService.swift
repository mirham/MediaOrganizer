//
//  FileService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import Foundation
import Combine
import Factory

class FileService : ServiceBase, FileServiceType {
    @Injected(\.metadataService) private var metadataService
    
    private let fileManager = FileManager.default
    
    func getFolderMediaFilesAsync(path: String) async -> [MediaFileInfo] {
        var result = [MediaFileInfo]()
        let path = URL( string: path)
        
        let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
        
        let filteredFileUrls = await listFilesInFolderAsync(at: path!, options: options).filter {
            $0.isImageFile || $0.isVideoFile
        }
        
        for await fileUrl in filteredFileUrls {
            let mediaType = fileUrl.isImageFile ? MediaType.photo : MediaType.video
            let metadata = await metadataService.getFileMetadataAsync(fileUrl: fileUrl)
            let mediaInfo = MediaFileInfo(type: mediaType, url: fileUrl, metadata: metadata)
            
            result.append(mediaInfo)
        }
        
        return result
    }
    
    func peformFileActionsAsync(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileActions: [FileAction]) async {
        do {
            try createFolderIfDoesNotExist(path: outputPath)
            fileInfo.currentUrl = try makeTempFileCopy(fileUrl:  fileInfo.currentUrl, outputPath: outputPath)
            
            for fileAction in fileActions {
                switch fileAction.actionType {
                    case .rename:
                        fileInfo.currentUrl = try renameFile(newName: fileAction.value!, fileUrl: fileInfo.currentUrl)
                    case .copyToFolder:
                        fileInfo.currentUrl = try copyToFolder(subfolderName: fileAction.value!, outputPath: outputPath, fileUrl: fileInfo.currentUrl)
                    case .moveToFolder:
                        fileInfo.currentUrl = try copyToFolder(subfolderName: fileAction.value!, outputPath: outputPath, fileUrl: fileInfo.currentUrl)
                        try deleteFile(fileUrl: fileInfo.originalUrl)
                    case .delete:
                        try deleteFile(fileUrl: fileInfo.currentUrl)
                        try deleteFile(fileUrl: fileInfo.originalUrl)
                    case .skip:
                        return
                }
            }
        }
        catch let fileActionException {
            print(fileActionException.localizedDescription)
        }
    }
    
    // MARK: Private functions
    
    func listFilesInFolderAsync(at url: URL, options: FileManager.DirectoryEnumerationOptions ) async -> AsyncStream<URL> {
        AsyncStream { continuation in
            Task {
                let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil, options: options)
                
                while let fileURL = enumerator?.nextObject() as? URL {
                    if fileURL.hasDirectoryPath {
                        for await item in await listFilesInFolderAsync(at: fileURL.standardizedFileURL, options: options) {
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
    
    private func createFolderIfDoesNotExist(path: String) throws {
        var isDir: ObjCBool = false
        
        if (!fileManager.fileExists(atPath: path, isDirectory: &isDir)) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
    }
    
    private func makeTempFileCopy(fileUrl: URL, outputPath: String) throws -> URL {
        let outputUrl = URL(fileURLWithPath: outputPath + fileUrl.lastPathComponent)
        
        try fileManager.copyItem(at: fileUrl, to: outputUrl)
        
        return outputUrl
    }
    
    private func renameFile(newName: String, fileUrl: URL) throws -> URL {
        let newUrl = URL(fileURLWithPath: fileUrl.deletingLastPathComponent().path() + newName)
        
        try fileManager.moveItem(at: fileUrl, to: newUrl)
        
        return newUrl
    }
    
    private func copyToFolder(subfolderName: String, outputPath: String, fileUrl: URL) throws -> URL {
        let subfolderPath = outputPath + subfolderName
        
        try createFolderIfDoesNotExist(path: subfolderPath)
        
        let newUrl = URL(fileURLWithPath: subfolderPath + Constants.slash + fileUrl.lastPathComponent)
        
        try fileManager.moveItem(at: fileUrl, to: newUrl)
        
        return newUrl
    }
    
    private func deleteFile(fileUrl: URL) throws {
        try fileManager.removeItem(at: fileUrl)
    }
}
