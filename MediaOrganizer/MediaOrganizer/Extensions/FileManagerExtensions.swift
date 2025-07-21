//
//  FileManagerExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 21.07.2025.
//

import Foundation

extension FileManager {
    func moveItemWithOverwriting(
        at source: URL,
        to destination: URL,
        overwrite: Bool = false,
        operationResult: inout OperationResult) throws {
        do {
            try moveItem(at: source, to: destination)
            operationResult.appendLogMessage(
                message: String(format: getFileActionMask(operationResult), source.absoluteString, destination.absoluteString),
                logLevel: .info)
        } catch let error as NSError {
            if error.code == NSFileWriteFileExistsError && overwrite {
                try removeItem(at: destination)
                try moveItem(at: source, to: destination)
                operationResult.appendLogMessage(
                    message: String(format: Constants.lmFileWasOverwritten, destination.absoluteString),
                    logLevel: .info)
            } else {
                throw error
            }
        }
    }
    
    func moveItemWithUniqueName(
        at source: URL,
        to destination: URL,
        operationResult: inout OperationResult) throws -> URL {
        var result = destination
        var counter = 1
        
        let fileName = destination.deletingPathExtension().lastPathComponent
        let fileExtension = destination.pathExtension
        
        while fileExists(atPath: result.path) {
            let newFileName = "\(fileName) \(counter).\(fileExtension)"
            result = destination.deletingLastPathComponent().appendingPathComponent(newFileName)
            counter += 1
        }
        
        try moveItem(at: source, to: result)
        
        operationResult.appendLogMessage(
            message: String(format: getFileActionMask(operationResult),
                            source.absoluteString, result.absoluteString)
            .appending(counter > 1 ? " \(Constants.lmAccordingToPolicy)" : String()),
            logLevel: .info)
            
        return result
    }
    
    func moveItemWithSkipIfDuplicate(
        at source: URL,
        to destination: URL,
        operationResult: inout OperationResult) throws {
            do {
                try moveItem(at: source, to: destination)
                operationResult.appendLogMessage(
                    message: String(format: getFileActionMask(operationResult),
                                    source.absoluteString, destination.absoluteString),
                    logLevel: .info)
            } catch let error as NSError {
                if error.code != NSFileWriteFileExistsError {
                    throw error
                }
                else {
                    operationResult.appendLogMessage(
                        message: String(format: Constants.lmFileSkippedDestinationExists,
                                        source.absoluteString, destination.absoluteString),
                        logLevel: .info)
                }
            }
        }
    
    // MARK: Private functions
    
    private func getFileActionMask(_ operationResult: OperationResult) -> String {
        switch operationResult.actionType {
            case .copyToFolder:
                return Constants.lmFileWasCopied
            case .moveToFolder:
                return Constants.lmFileWasMoved
            default:
                return String()
        }
    }
}
