//
//  ActionService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import Foundation

class ActionService : ServiceBase, ActionServiceType {    
    func removeActionById(actionId: UUID) {
        guard appState.current.rule != nil else { return }
        
        if let actionIndex = appState.current.rule!.actions.firstIndex(where: { $0.id == actionId }) {
            appState.current.rule!.actions.remove(at: actionIndex)
            appState.objectWillChange.send()
        }
    }
    
    func removeCurrentAction() {
        guard doesCurrentRuleExist() && doesCurrentActionExist() else { return }
        
        if let actionIndex = appState.current.rule!.actions.firstIndex(where: { $0.id == appState.current.action!.id }) {
            appState.current.rule!.actions.remove(at: actionIndex)
            appState.objectWillChange.send()
        }
    }
    
    func isCurrentAction(actionId: UUID) -> Bool {
        guard doesCurrentActionExist() else { return false }
        
        let result = appState.current.action!.id == actionId
        
        return result
    }
}
