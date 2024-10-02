//
//  ActionService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import Foundation

class ActionService : ServiceBase {
    static let shared = ActionService()
    
    func removeCurrentAction() {
        guard appState.current.rule != nil && appState.current.action != nil else { return }
        
        if let actionIndex = appState.current.rule!.actions.firstIndex(where: { $0.id == appState.current.action!.id }) {
            appState.current.rule!.actions.remove(at: actionIndex)
            appState.objectWillChange.send()
        }
    }
}
