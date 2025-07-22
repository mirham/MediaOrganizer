//
//  FileActionStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol FileActionStrategy {
    var actionType: ActionType { get }
    
    func performAction(
        outputPath: String,
        fileInfo: MediaFileInfo,
        fileAction: FileAction,
        duplicatesPolicy: DuplicatesPolicy,
        operationResult: inout OperationResult)
}
