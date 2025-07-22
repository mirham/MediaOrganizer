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
        let url = URL(fileURLWithPath: path, isDirectory: true)
        let result = (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
        
        return result
    }
    
    func getFolderMediaFilesAsync (
        path: String,
        jobProgress: JobProgress) async throws -> [MediaFileInfo] {
        var result = [MediaFileInfo]()
        let path = URL(string: path)
        
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
    
    func peformFileActionsAsync (
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
    
    func renameFile (
        newName: String,
        fileUrl: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) {
        let newUrl = URL(string: "\(fileUrl.deletingLastPathComponent().path())\(newName)")
        guard let newUrl = newUrl else { return }
        
        do {
            let adjustedNewUrl = try processFileWithDuplicatesPolicy(
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
    
    func copyOrMoveToFolder (
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
        
        let newUrl = URL(
            fileURLWithPath: "\(subfolderPath)\(fileUrl.lastPathComponent)",
            isDirectory: false)
        
        do {
            let adjustedNewUrl = try processFileWithDuplicatesPolicy(
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
    
    func deleteFile (
        fileUrl: URL,
        operationResult: inout OperationResult) {
        do {
            try fileManager.removeItem(at: fileUrl)
            operationResult.appendLogMessage(
                message: String(
                    format: Constants.lmFileWasDeleted,
                    fileUrl.path(percentEncoded: false)),
                logLevel: .info)
        }
        catch {
            handlePerformActionException(
                errorDescription: error.localizedDescription,
                operationResult: &operationResult)
        }
    }
    
    // MARK: Private functions
    
    private func listFilesInFolderAsync (
        at url: URL,
        options: FileManager.DirectoryEnumerationOptions,
        jobProgress: JobProgress) async -> AsyncStream<URL> {
        AsyncStream { continuation in
            Task {
                do {
                    let standardizedURL = url.standardizedFileURL
                    let enumerator = FileManager.default.enumerator(
                        at: standardizedURL,
                        includingPropertiesForKeys: [.isDirectoryKey],
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
    
    private func createFolderIfDoesNotExist (
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
    
    private func checkIfActionNeeded (
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
    
    private func processFileWithDuplicatesPolicy (
        at source: URL,
        to destination: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) throws -> URL? {
        switch duplicatesPolicy {
            case .overwrite:
                try fileManager.processItemWithOverwriting(
                    at: source,
                    to: destination,
                    overwrite: true,
                    operationResult: &operationResult)
                return nil
            case .keep:
               return try fileManager.processItemWithUniqueName(
                    at: source,
                    to: destination,
                    operationResult: &operationResult)
            case .skip:
                try fileManager.processItemWithSkipIfDuplicate(
                    at: source,
                    to: destination,
                    operationResult: &operationResult)
                return nil
        }
    }
    
    private func handlePerformActionException (
        errorDescription: String,
        operationResult: inout OperationResult) {
        var message: String
        switch operationResult.actionType {
            case .rename:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.rename.description,
                                 operationResult.originalUrl.path(percentEncoded: false),
                                 errorDescription)
            case .copyToFolder:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.copyToFolder.description,
                                 operationResult.originalUrl.path(percentEncoded: false),
                                 errorDescription)
            case .moveToFolder:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.moveToFolder.description,
                                 operationResult.originalUrl.path(percentEncoded: false),
                                 errorDescription)
            case .delete:
                message = String(format: Constants.errorCannotPerformAction,
                                 ActionType.delete.description,
                                 operationResult.originalUrl.path(percentEncoded: false),
                                 errorDescription)
            default:
                message = String(format: Constants.errorCannotPerformAction2,
                                 operationResult.originalUrl.path(percentEncoded: false),
                                 errorDescription)
        }
        
        fileManager.restoreFile(operationResult: &operationResult)
        operationResult.appendLogMessage(message: message, logLevel: .error)
    }
}

private extension FileManager {
    func processItemWithOverwriting (
        at source: URL,
        to destination: URL,
        overwrite: Bool = false,
        operationResult: inout OperationResult) throws {
            do {
                try performFileAction(
                    at: source,
                    to: destination,
                    operationResult)
                
                operationResult.appendLogMessage(
                    message: String(
                        format: getFileActionMask(operationResult),
                        source.path(percentEncoded: false),
                        destination.path(percentEncoded: false)),
                    logLevel: .info)
            } catch let error as NSError {
                if error.code == NSFileWriteFileExistsError && overwrite {
                    let sourcePath = source.standardized.path(percentEncoded: false)
                    let destinationPath = destination.standardized.path(percentEncoded: false)
                    
                    try removeItem(atPath: destinationPath)
                    try moveItem(atPath: sourcePath, toPath: destinationPath)
                    
                    operationResult.appendLogMessage(
                        message: String(
                            format: Constants.lmFileWasOverwritten,
                            destination.path(percentEncoded: false)),
                        logLevel: .info)
                } else {
                    throw error
                }
            }
        }
    
    func processItemWithUniqueName (
        at source: URL,
        to destination: URL,
        operationResult: inout OperationResult) throws -> URL {
            var result = destination
            var counter = 1
            
            let fileName = destination.deletingPathExtension().lastPathComponent
            let fileExtension = destination.pathExtension
            let isFileHasProperName = source.standardized.path(percentEncoded: false)
                == destination.standardized.path(percentEncoded: false)
                && operationResult.actionType == .rename
            
            if isFileHasProperName {
                operationResult.appendLogMessage(
                    message: String(format: Constants.lmFileRenamingSkipped, result.path(percentEncoded: false)),
                    logLevel: .info)
                return result
            }
            
            while fileExists(atPath: result.path) {
                let newFileName = "\(fileName) \(counter).\(fileExtension)"
                result = destination.deletingLastPathComponent().appendingPathComponent(newFileName)
                counter += 1
            }
            
            try performFileAction(
                at: source,
                to: result,
                operationResult)
            
            let message = String(format: getFileActionMask(operationResult),
                                 source.path(percentEncoded: false),
                                 result.path(percentEncoded: false),
                                 counter > 1 ? " \(Constants.lmAccordingToPolicy)" : String())
            
            operationResult.appendLogMessage(
                message: message,
                logLevel: .info)
            
            return result
        }
    
    func processItemWithSkipIfDuplicate(
        at source: URL,
        to destination: URL,
        operationResult: inout OperationResult) throws {
        do {
            try performFileAction(
                at: source,
                to: destination,
                operationResult)
                
            operationResult.appendLogMessage(
                message: String(format: getFileActionMask(operationResult),
                                source.path(percentEncoded: false),
                                destination.path(percentEncoded: false)),
                logLevel: .info)
        }
        catch let error as NSError {
            if error.code != NSFileWriteFileExistsError {
                throw error
            }
            else {
                restoreFile(operationResult: &operationResult)
                
                operationResult.appendLogMessage(
                    message: String(format: Constants.lmFileSkippedDestinationExists,
                                    source.path(percentEncoded: false),
                                    operationResult.originalUrl.path(percentEncoded: false),
                                    destination.path(percentEncoded: false)),
                    logLevel: .info)
            }
        }
    }
    
     func restoreFile (operationResult: inout OperationResult) {
        let originalPath = operationResult.originalUrl.standardized.path(percentEncoded: false)
        let currentPath = operationResult.currentUrl.standardized.path(percentEncoded: false)
        
        do {
            if fileExists(atPath: originalPath) {
                if originalPath != currentPath {
                    try removeItem(atPath: currentPath)
                }
            }
            else {
                try moveItem(atPath: currentPath, toPath: originalPath)
            }
        }
        catch {
            operationResult.appendLogMessage(
                message: String(format: Constants.errorFatalCannotRestoreFile,
                                operationResult.originalUrl.path(percentEncoded: false)),
                logLevel: .error)
        }
    }
    
    // MARK: Private functions
    
    private func getFileActionMask (_ operationResult: OperationResult) -> String {
        switch operationResult.actionType {
            case .copyToFolder:
                return Constants.lmFileWasCopied
            case .moveToFolder:
                return Constants.lmFileWasMoved
            case .rename:
                return Constants.lmFileWasRenamed
            default:
                return String()
        }
    }
    
    private func performFileAction (
        at source: URL,
        to destination: URL,
        _ operationResult: OperationResult) throws {
        switch operationResult.actionType {
            case .copyToFolder:
                try copyItem(
                    atPath: source.standardized.path(percentEncoded: false),
                    toPath: destination.standardized.path(percentEncoded: false))
            case .moveToFolder, .rename:
                try moveItem(
                    atPath: source.standardized.path(percentEncoded: false),
                    toPath: destination.standardized.path(percentEncoded: false))
            default:
                let error = String(format: Constants.errorCannotPerformFileAction, operationResult.actionType?.description ?? String())
                throw error
        }
    }
}
