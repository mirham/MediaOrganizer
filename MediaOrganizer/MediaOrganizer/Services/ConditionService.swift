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
    @Injected(\.elementStrategyFactory) private var elementStrategyFactory
    
    func addNewCondition() {
        guard let currentRule = appState.current.rule else { return }
        
        let conditionType = currentRule.conditions.count == 0
            ? ConditionType.cIf
            : ConditionType.cElseIf
        
        let newCondition = Condition()
        newCondition.type = conditionType
        
        currentRule.conditions.append(newCondition)
    }
    
    func isCurrentCondition(conditionId: UUID) -> Bool {
        guard let currentCondition = appState.current.condition else { return false }
        
        let result = currentCondition.id == conditionId
        
        return result
    }
    
    func applyConditions(
        conditions: [Condition],
        fileInfo: MediaFileInfo) -> Bool {
        guard !conditions.isEmpty else { return false }
        
        for condition in conditions {
            for element in condition.elements {
                element.fileMetadata = fileInfo.metadata
            }
            
            do {
                let parser = ExpressionParser(elements: condition.elements)
                let ast = try parser.parse()
                let isMatch = try ast.evaluate(elementStrategyFactory)
                
                if isMatch {
                    return true
                }
            }
            catch {
                // TODO: Log needed.
                print("Error when parsing:" + error.localizedDescription)
            }
        }
        
        return false
    }
    
    func replaceCondition(conditionId: UUID, condition: Condition) {
        guard let currentRule = appState.current.rule else { return }
        
        if let conditionIndex = currentRule.conditions.firstIndex(where: { $0.id == conditionId }) {
            currentRule.conditions[conditionIndex] = condition
            
            appState.current.refreshSignal.toggle()
        }
    }
    
    func removeConditionById(conditionId: UUID) {
        guard let currentRule = appState.current.rule else { return }
        
        if let conditionIndex = currentRule.conditions.firstIndex(where: { $0.id == conditionId }) {
            currentRule.conditions.remove(at: conditionIndex)
            
            if (conditionIndex == 0 || currentRule.conditions.count == 1) {
                currentRule.conditions.first?.type = .cIf
            }
            
            appState.current.refreshSignal.toggle()
        }
    }
}
