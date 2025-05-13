//
//  SkipStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class SkipStrategy : FileActionStrategy {
    let actionType: ActionType = ActionType.skip
    
    func performAction(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileAction: FileAction) throws -> URL? {
        return nil
    }
}
