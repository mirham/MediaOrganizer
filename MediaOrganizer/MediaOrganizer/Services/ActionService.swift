//
//  ActionService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import Foundation
import Factory

class ActionService : ServiceBase, ActionServiceType {
    @Injected(\.elementService) private var elementService
    
    func addNewAction() {
        appState.current.rule!.actions.append(Action())
    }
    
    func isCurrentAction(actionId: UUID) -> Bool {
        guard doesCurrentActionExist() else { return false }
        
        let result = appState.current.action!.id == actionId
        
        return result
    }
    
    func actionToFileAction(action: Action, fileInfo: MediaFileInfo) -> FileAction {
        var value: String = String()
        
        for element in action.elements {
            element.fileMetadata = fileInfo.metadata
            guard let stringElement = elementService.elementAsString(element: element)
            else { return FileAction(actionType: .skip, value: nil) }
            
            value.append(stringElement)
        }
        
        return FileAction(actionType: action.type, value: value)
    }
    
    func removeActionById(actionId: UUID) {
        guard appState.current.rule != nil else { return }
        
        if let actionIndex = appState.current.rule!.actions.firstIndex(where: { $0.id == actionId }) {
            appState.current.rule!.actions.remove(at: actionIndex)
            appState.objectWillChange.send()
        }
    }
}
