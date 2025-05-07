//
//  ConditionService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2024.
//

import Foundation
import Factory

class ConditionService : ServiceBase, ConditionServiceType {
    @Injected(\.elementService) private var elementService
    
    func isCurrentCondition(conditionId: UUID) -> Bool {
        guard doesCurrentConditionExist() else { return false }
        
        let result = appState.current.condition!.id == conditionId
        
        return result
    }
    
    func removeConditionById(conditionId: UUID) {
        guard appState.current.rule != nil else { return }
        
        if let conditionIndex = appState.current.rule!.conditions.firstIndex(where: { $0.id == conditionId }) {
            appState.current.rule!.conditions.remove(at: conditionIndex)
            appState.objectWillChange.send()
        }
    }
    
    func removeCurrentCondition() {
        guard doesCurrentRuleExist() && doesCurrentConditionExist() else { return }
        
        if let conditionIndex = appState.current.rule!.conditions.firstIndex(where: { $0.id == appState.current.condition!.id }) {
            appState.current.rule!.conditions.remove(at: conditionIndex)
            appState.objectWillChange.send()
        }
    }
}
