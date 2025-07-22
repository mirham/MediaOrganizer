//
//  DeleteStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class DeleteStrategy : FileActionStrategy {
    @Injected(\.fileService) private var fileService
    
    let actionType: ActionType = ActionType.delete
    
    func performAction(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileAction: FileAction,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) {
        fileService.deleteFile(
            fileUrl: fileInfo.originalUrl,
            operationResult: &operationResult)
    }
}
