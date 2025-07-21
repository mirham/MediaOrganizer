//
//  CopyToFolderStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class CopyToFolderStrategy : FileActionStrategy {
    @Injected(\.fileService) private var fileService
    
    let actionType: ActionType = ActionType.copyToFolder
    
    func performAction(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileAction: FileAction,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult) {
            fileService.copyToFolder(
            subfolderName: fileAction.value!,
            outputPath: outputPath,
            fileUrl: fileInfo.currentUrl,
            duplicatesPolicy: duplicatesPolicy,
            operationResult: &operationResult)
    }
}
