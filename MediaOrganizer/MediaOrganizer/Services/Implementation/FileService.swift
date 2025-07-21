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
        fileActions: [FileAction],
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) async {
        createFolderIfDoesNotExist(
            path: outputPath,
            operationResult: &operationResult)
            
        guard operationResult.isSuccess else { return }
            
        guard checkIfActionNeeded(fileActions: fileActions, operationResult: &operationResult)
        else { return }
            
        makeTempFileCopy(
            fileUrl: fileInfo.currentUrl,
            outputPath: outputPath,
            fileActions: fileActions,
            operationResult: &operationResult)
            
        guard operationResult.isSuccess else { return }
            
        fileInfo.currentUrl = operationResult.currentUrl
        
        for fileAction in fileActions {
            let fileActionStrategy = fileActionStrategyFactory.getStrategy(
                actionType: fileAction.actionType)
            
            operationResult.actionType = fileAction.actionType
            
            fileActionStrategy?.performAction(
                outputPath: outputPath,
                fileInfo: fileInfo,
                fileAction: fileAction,
                duplicatesPolicy: duplicatesPolicy,
                operationResult: &operationResult)
            
            guard operationResult.isSuccess else { return }
            
            fileInfo.currentUrl = operationResult.currentUrl
        }
    }
    
    func renameFile(
        newName: String,
        fileUrl: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) {
        let newUrl = URL(fileURLWithPath: fileUrl.deletingLastPathComponent().path() + newName)
        
        do {
            let adjustedNewUrl = try moveFileWithDuplicatesPolicy(
                at: fileUrl,
                to: newUrl,
                duplicatesPolicy: duplicatesPolicy,
                operationResult: &operationResult)
            
            operationResult.currentUrl = adjustedNewUrl ?? newUrl
        }
        catch {
            handlePerformActionException(
                errorDescription: error.localizedDescription,
                operationResult: &operationResult)
        }
    }
    
    func copyToFolder(
        subfolderName: String,
        outputPath: String,
        fileUrl: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) {
        let subfolderPath = outputPath + subfolderName
        
        createFolderIfDoesNotExist(
            path: subfolderPath,
            operationResult: &operationResult)
        
        guard operationResult.isSuccess
        else { return }
        
        let newUrl = URL(fileURLWithPath: "\(subfolderPath)\(Constants.slash)\(fileUrl.lastPathComponent)")
        
        do {
            let adjustedNewUrl = try moveFileWithDuplicatesPolicy(
                at: fileUrl,
                to: newUrl,
                duplicatesPolicy: duplicatesPolicy,
                operationResult: &operationResult)
            operationResult.currentUrl = adjustedNewUrl ?? newUrl
        }
        catch {
            handlePerformActionException(
                errorDescription: error.localizedDescription,
                operationResult: &operationResult)
        }
    }
    
    func deleteFile(
        fileUrl: URL,
        operationResult: inout OperationResult) {
        do {
            try fileManager.removeItem(at: fileUrl)
            operationResult.appendLogMessage(
                message: String(format: Constants.lmFileWasDeleted, fileUrl.absoluteString),
                logLevel: .info)
        }
        catch {
            handlePerformActionException(
                errorDescription: error.localizedDescription,
                operationResult: &operationResult)
        }
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
    
    private func createFolderIfDoesNotExist(
        path: String,
        operationResult: inout OperationResult) {
        do {
            if !doesFolderExist(path: path) {
                try fileManager.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true)
            }
        }
        catch {
            operationResult.appendLogMessage(
                message: String(format: Constants.errorCannotCreateFolder, path, error.localizedDescription),
                logLevel: .error)
        }
    }
    
    private func checkIfActionNeeded(
        fileActions: [FileAction],
        operationResult: inout OperationResult) -> Bool {
        if !fileActions.isEmpty && !fileActions.allSatisfy({$0.actionType == .skip}) {
            return true
        }
        
        operationResult.appendLogMessage(
            message: String(format: Constants.lmFileSkipped, operationResult.originalUrl.absoluteString),
            logLevel: .info)
            
        return false
    }
    
    private func makeTempFileCopy(
        fileUrl: URL,
        outputPath: String,
        fileActions: [FileAction],
        operationResult: inout OperationResult) {
        let isDeleteOnly = fileActions.count == 1
        && fileActions.allSatisfy({$0.actionType == .delete})
        
        if !isDeleteOnly {
            let uuid = UUID().toStringWithoutHyphens
            let outputUrl = URL(fileURLWithPath: "\(outputPath).\(uuid)_\(fileUrl.lastPathComponent)")
         
            do {
                try fileManager.copyItem(at: fileUrl, to: outputUrl)
                operationResult.currentUrl = outputUrl
            }
            catch {
                operationResult.appendLogMessage(
                    message: String(format: Constants.errorCannotCreateTempFile, error.localizedDescription),
                    logLevel: .error)
            }
        }
    }
    
    private func moveFileWithDuplicatesPolicy(
        at source: URL,
        to destination: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) throws -> URL? {
        switch duplicatesPolicy {
            case .overwrite:
                try fileManager.moveItemWithOverwriting(
                    at: source,
                    to: destination,
                    overwrite: true,
                    operationResult: &operationResult)
                return nil
            case .keep:
               return try fileManager.moveItemWithUniqueName(
                    at: source,
                    to: destination,
                    operationResult: &operationResult)
            case .skip:
                try fileManager.moveItemWithSkipIfDuplicate(
                    at: source,
                    to: destination,
                    operationResult: &operationResult)
                return nil
        }
    }
    
    private func handlePerformActionException(
        errorDescription: String,
        operationResult: inout OperationResult) {
        var message: String
        switch operationResult.actionType {
            case .rename:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.rename.description,
                                 operationResult.originalUrl.absoluteString,
                                 errorDescription)
            case .copyToFolder:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.copyToFolder.description,
                                 operationResult.originalUrl.absoluteString,
                                 errorDescription)
            case .moveToFolder:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.moveToFolder.description,
                                 operationResult.originalUrl.absoluteString,
                                 errorDescription)
            case .delete:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.delete.description,
                                 operationResult.originalUrl.absoluteString,
                                 errorDescription)
            default:
                message = String(format: Constants.errorCannotPerformAction2,
                                 operationResult.originalUrl.absoluteString,
                                 errorDescription)
        }
            
        operationResult.appendLogMessage(message: message, logLevel: .error)
    }
}
