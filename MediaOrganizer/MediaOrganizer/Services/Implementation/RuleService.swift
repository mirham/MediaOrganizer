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
    @Injected(\.validationService) private var validationService
    
    func createRule() {
        appState.current.rule = Rule()
    }
    
    func doesCurrentRuleExist() -> Bool {
        guard appState.current.rule != nil else { return false }
        
        return true
    }
    
    func isCurrentRule(ruleId: UUID) -> Bool {
        guard let currentRule = appState.current.rule
        else { return false }
        
        let result = currentRule.id == ruleId
        
        return result
    }
    
    func getRuleIndexByRuleId(ruleId: UUID) -> Int? {
        guard let currentJob = appState.current.job else { return nil }
        
        return currentJob.rules.firstIndex(where: {$0.id == ruleId})
    }
    
    func addRule() {
        guard let currentJob = appState.current.job,
              let currentRule = appState.current.rule
        else { return }
        
        currentJob.rules.append(currentRule)
    }
    
    func duplicateRule() {
        guard let currentJob = appState.current.job,
              let currentRule = appState.current.rule
        else { return }
        
        let duplicatedRule = currentRule.clone()
        
        currentJob.rules.append(duplicatedRule)
    }
    
    func updateRule() {
        guard let currentJob = appState.current.job,
              let currentRule = appState.current.rule
        else { return }
        
        if let ruleIndex = getRuleIndexByRuleId(ruleId: getCurrentRuleId()!) {
            currentJob.rules[ruleIndex] = currentRule
        }
    }
    
    func moveRuleUp() {
        guard let currentJob = appState.current.job,
              let ruleId = getCurrentRuleId(),
              let ruleIndex = getRuleIndexByRuleId(ruleId: ruleId) else {
            return
        }
        
        guard ruleIndex > 0 else { return }
        
        currentJob.rules.swapAt(ruleIndex, ruleIndex - 1)
    }
    func moveRuleDown() {
        guard let currentJob = appState.current.job,
              let ruleId = getCurrentRuleId(),
              let ruleIndex = getRuleIndexByRuleId(ruleId: ruleId) else {
            return
        }
        
        guard ruleIndex < currentJob.rules.count - 1 else { return }
        
        currentJob.rules.swapAt(ruleIndex, ruleIndex + 1)
    }
    
    func applyRule(
        rule:Rule,
        fileInfo: MediaFileInfo,
        operationResult: inout OperationResult) throws -> [FileAction] {
        let emptyResult = [FileAction]()
        var result = [FileAction]()
        
        let matchAnyCondition = rule.conditions.isEmpty
            ? true
            : try conditionService.applyConditions(
                conditions: rule.conditions,
                fileInfo: fileInfo)
        
        guard matchAnyCondition else { return emptyResult }
        
        for action in rule.actions {
            guard let fileAction = actionService.actionToFileAction(
                action: action, fileInfo: fileInfo)
            else {
                operationResult.appendLogMessage(
                    message: String(format: Constants.lmCannotMakeFileAction, action.description()),
                    logLevel: .warning)
                return emptyResult
            }
            
            result.append(fileAction)
        }
        
        return result
    }
    
    func validateRule(rule: Rule?) {
        guard let currentRule = rule else { return }
        
        var isValid: Bool
        var message: String?
        var severity: ValidationSeverity?
        
        let conditionsValidationResult = validationService.areValidConditions(
            conditions: currentRule.conditions)
        
        isValid = conditionsValidationResult.isValid
        message = conditionsValidationResult.message
        severity = conditionsValidationResult.severity
        
        if isValid {
            let actionsValidationResult = validationService.areValidActions(
                actions: currentRule.actions)
            
            isValid = actionsValidationResult.isValid
            message = actionsValidationResult.message
            severity = actionsValidationResult.severity
        }
        
        currentRule.validation.isValid = isValid
        currentRule.validation.message = message
        currentRule.validation.severity = severity
    }
    
    func resetCurrentRule() {
        appState.current.rule = nil
    }
    
    func removeCurrentRule() {
        guard let currentJob = appState.current.job
        else { return }
        
        if let ruleIndex = getRuleIndexByRuleId(ruleId: getCurrentRuleId()!) {
            currentJob.rules.remove(at: ruleIndex)
            resetCurrentRule()
        }
    }
    
    // MARK: Private functions
    
    private func getCurrentRuleId() -> UUID? {
        guard let currentRule = appState.current.rule
        else { return nil }
        
        return currentRule.id
    }
}
