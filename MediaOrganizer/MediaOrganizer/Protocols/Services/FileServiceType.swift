//
//  FileServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol FileServiceType {
    func doesFolderExist(path: String) -> Bool
    func getFolderMediaFilesAsync(
        path: String,
        jobProgress: JobProgress) async throws -> [MediaFileInfo]
    func peformFileActionsAsync(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileActions: [FileAction],
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) async
    func renameFile(
        newName: String,
        fileUrl: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult)
    func copyOrMoveToFolder(
        subfolderName: String,
        outputPath: String,
        fileUrl: URL,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult)
    func deleteFile(
        fileUrl: URL,
        operationResult: inout OperationResult)
}
