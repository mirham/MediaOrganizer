//
//  ServiceBase.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class ServiceBase : ServiceBaseType {
    let appState = AppState.shared
    
    internal func doesCurrentJobExist() -> Bool {
        guard appState.current.job != nil else { return false }
        
        return true
    }
    
    internal func getCurrentJobId() -> UUID? {
        guard doesCurrentJobExist() else { return nil }
        
        let result = appState.current.job!.id
        
        return result
    }
    
    internal func getJobIndexByJobId(jobId: UUID) -> Int? {
        let result = appState.userData.jobs.firstIndex(where: {$0.id == jobId})
        
        return result
    }
    
    internal func doesCurrentRuleExist() -> Bool {
        guard appState.current.rule != nil else { return false }
        
        return true
    }
    
    internal func getCurrentRuleId() -> UUID? {
        guard doesCurrentRuleExist() else { return nil }
        
        let result = appState.current.rule!.id
        
        return result
    }
    
    internal func getRuleIndexByRuleId(ruleId: UUID) -> Int? {
        guard doesCurrentJobExist() else { return nil }
        
        let result = appState.current.job!.rules.firstIndex(where: {$0.id == ruleId})
        
        return result
    }
    
    internal func doesCurrentActionExist() -> Bool {
        guard appState.current.action != nil else { return false }
        
        return true
    }
    
    internal func doesCurrentConditionExist() -> Bool {
        guard appState.current.condition != nil else { return false }
        
        return true
    }
}
