//
//  RuleService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.09.2024.
//

import Foundation
import Factory

class RuleService: ServiceBase, RuleServiceType {
    @Injected(\.actionService) private var actionService
    @Injected(\.conditionService) private var conditionService
    
    func createRule() {
        appState.current.rule = Rule()
    }
    
    func addRule() {
        guard doesCurrentJobExist() && doesCurrentRuleExist() else { return }
        
        appState.current.job!.rules.append(appState.current.rule!)
    }
    
    func updateRule() {
        guard doesCurrentJobExist() && doesCurrentRuleExist() else { return }
        
        if let ruleIndex = getRuleIndexByRuleId(ruleId: getCurrentRuleId()!) {
            appState.current.job!.rules[ruleIndex] = appState.current.rule!
        }
    }
    
    func isCurrentRule(ruleId: UUID) -> Bool {
        guard doesCurrentRuleExist() else { return false }
        
        let result = appState.current.rule!.id == ruleId
        
        return result
    }
    
    func applyRule(rule:Rule, fileInfo: MediaFileInfo) -> [FileAction] {
        var result = [FileAction]()
        
        let matchAllConditions = conditionService.applyConditions(conditions: rule.conditions, fileInfo: fileInfo)
        
        guard matchAllConditions else { return result }
        
        for action in rule.actions {
            let fileAction = actionService.actionToFileAction(
                action: action, fileInfo: fileInfo)
            
            result.append(fileAction)
        }
        
        return result
    }
    
    func resetCurrentRule() {
        appState.current.rule = nil
    }
    
    func removeCurrentRule() {
        guard appState.current.job != nil else { return }
        
        if let ruleIndex = getRuleIndexByRuleId(ruleId: getCurrentRuleId()!) {
            appState.current.job!.rules.remove(at: ruleIndex)
            resetCurrentRule()
        }
    }
}
