//
//  RuleService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.09.2024.
//

import Foundation

class RuleService: ServiceBase, RuleServiceType {    
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
