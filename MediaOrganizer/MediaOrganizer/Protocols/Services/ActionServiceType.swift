//
//  ActionServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol ActionServiceType : ServiceBaseType {
    func addNewAction()
    func isCurrentAction(actionId: UUID) -> Bool
    func actionToFileAction(action: Action, fileInfo: MediaFileInfo) -> FileAction
    func replaceAction(actionId: UUID, action: Action)
    func removeActionById(actionId: UUID)
}
