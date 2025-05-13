//
//  ConditionService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import Foundation
import Factory

class ConditionService : ServiceBase, ConditionServiceType {
    @Injected(\.elementService) private var elementService
    
    func addNewCondition() {
        let conditionType = appState.current.rule!.conditions.count == 0
            ? ConditionType.cIf
            : ConditionType.cElseIf
        
        let newCondition = Condition()
        newCondition.type = conditionType
        
        appState.current.rule!.conditions.append(newCondition)
    }
    
    func isCurrentCondition(conditionId: UUID) -> Bool {
        guard doesCurrentConditionExist() else { return false }
        
        let result = appState.current.condition!.id == conditionId
        
        return result
    }
    
    func removeConditionById(conditionId: UUID) {
        guard appState.current.rule != nil else { return }
        
        if let conditionIndex = appState.current.rule!.conditions.firstIndex(where: { $0.id == conditionId }) {
            appState.current.rule!.conditions.remove(at: conditionIndex)
            
            if (conditionIndex == 0 || appState.current.rule!.conditions.count == 1) {
                appState.current.rule!.conditions.first?.type = .cIf
            }
            
            appState.objectWillChange.send()
        }
    }
}
