//
//  RenameStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class RenameStrategy : FileActionStrategy {
    @Injected(\.fileService) private var fileService
    
    let actionType: ActionType = ActionType.rename
    
    func performAction(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileAction: FileAction) throws -> URL? {
        let result = try fileService.renameFile(
            newName: fileAction.value!,
            fileUrl: fileInfo.currentUrl)
        
        return result
    }
}
