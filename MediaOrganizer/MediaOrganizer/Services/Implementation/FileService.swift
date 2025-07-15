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
    @Injected(\.fileActionStrategyFactory) private var fileActionStrategyFactory
    
    private let fileManager = FileManager.default
    
    func doesFolderExist(path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        let result = (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
        
        return result
    }
    
    func getFolderMediaFilesAsync(
        path: String,
        jobProgress: JobProgress) async throws -> [MediaFileInfo] {
        var result = [MediaFileInfo]()
        let path = URL( string: path)
        
        let options: FileManager.DirectoryEnumerationOptions
            = [.skipsHiddenFiles, .skipsPackageDescendants]
        
        let filteredFileUrls = await
            listFilesInFolderAsync(
                at: path!,
                options: options,
                jobProgress: jobProgress)
            .filter { $0.isImageFile || $0.isVideoFile }
        
        for await fileUrl in filteredFileUrls {
            print(fileUrl.absoluteString)
            try Task.checkCancellation()
            
            if jobProgress.isCancelled {
                throw CancellationError()
            }
            
            let mediaType = fileUrl.isImageFile ? MediaType.photo : MediaType.video
            let metadata = try await metadataService.getFileMetadataAsync(fileUrl: fileUrl)
            let mediaInfo = MediaFileInfo(type: mediaType, url: fileUrl, metadata: metadata)
            
            result.append(mediaInfo)
        }
        
        return result
    }
    
    func peformFileActionsAsync(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileActions: [FileAction]) async throws {
        try createFolderIfDoesNotExist(path: outputPath)
        fileInfo.currentUrl = try makeTempFileCopy(
            fileUrl: fileInfo.currentUrl,
            outputPath: outputPath)
        
        for fileAction in fileActions {
            let fileActionStrategy = fileActionStrategyFactory.getStrategy(
                actionType: fileAction.actionType)
            let currentUrl = try fileActionStrategy?.performAction(
                outputPath: outputPath,
                fileInfo: fileInfo,
                fileAction: fileAction)
            
            if let currentUrl = currentUrl {
                fileInfo.currentUrl = currentUrl
            }
        }
    }
    
    func renameFile(newName: String, fileUrl: URL) throws -> URL {
        let newUrl = URL(fileURLWithPath: fileUrl.deletingLastPathComponent().path() + newName)
        
        try fileManager.moveItem(at: fileUrl, to: newUrl)
        
        return newUrl
    }
    
    func copyToFolder(
        subfolderName: String,
        outputPath: String,
        fileUrl: URL) throws -> URL {
        let subfolderPath = outputPath + subfolderName
        
        try createFolderIfDoesNotExist(path: subfolderPath)
        
        let newUrl = URL(fileURLWithPath: "\(subfolderPath)\(Constants.slash)\(fileUrl.lastPathComponent)")
        
        try fileManager.moveItem(at: fileUrl, to: newUrl)
        
        return newUrl
    }
    
    func deleteFile(fileUrl: URL) throws {
        try fileManager.removeItem(at: fileUrl)
    }
    
    // MARK: Private functions
    
    private func listFilesInFolderAsync(
        at url: URL,
        options: FileManager.DirectoryEnumerationOptions,
        jobProgress: JobProgress) async -> AsyncStream<URL> {
        AsyncStream { continuation in
            Task {
                do {
                    let enumerator = FileManager.default.enumerator(
                        at: url,
                        includingPropertiesForKeys: nil,
                        options: options
                    )
                    
                    while let fileURL = enumerator?.nextObject() as? URL {
                        try Task.checkCancellation()
                        
                        if jobProgress.isCancelled {
                            continuation.finish()
                            return
                        }
                        
                        if !fileURL.hasDirectoryPath {
                            continuation.yield(fileURL)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish()
                }
            }
        }
    }
    
    private func createFolderIfDoesNotExist(path: String) throws {
        if (!doesFolderExist(path: path)) {
            try fileManager.createDirectory(
                atPath: path,
                withIntermediateDirectories: true)
        }
    }
    
    private func makeTempFileCopy(fileUrl: URL, outputPath: String) throws -> URL {
        let outputUrl = URL(fileURLWithPath: outputPath + fileUrl.lastPathComponent)
        
        try fileManager.copyItem(at: fileUrl, to: outputUrl)
        
        return outputUrl
    }
}
