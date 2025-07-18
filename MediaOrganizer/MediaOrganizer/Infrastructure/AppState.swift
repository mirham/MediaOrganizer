//
//  AppState.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

class AppState : ObservableObject {
    @Published var userData = UserData()
    @Published var current = Current()
    @Published var views = Views()
    
    static let shared = AppState()
}

extension AppState {
    struct Current : Equatable {
        var refreshSignal: Bool = false
        var job: Job? = nil
        var rule: Rule? = nil
        var condition: Condition? = nil
        var isConditionInEditMode = false
        var conditionElement: ConditionElement? = nil
        var isConditionElementInEditMode = false
        var action: Action? = nil
        var isActionInEditMode = false
        var actionElement: ActionElement? = nil
        var isActionElementInEditMode = false
        var logJobId: UUID? = nil
        var validationMessage: String? = nil
        
        var isRuleInSetupMode: Bool {
            get {
                return isConditionInEditMode || isActionInEditMode
            }
        }
        
        var isRuleSetupComplete: Bool {
            get {
                return !isConditionInEditMode
                    && !isActionInEditMode
                    && validationMessage == nil
            }
        }
        
        var isRuleElementSetupComplete: Bool {
            get {
                return !isConditionElementInEditMode
                    && !isActionElementInEditMode
            }
        }
        
        var allRulesValid: Bool {
            get {
                if let currentJob = job {
                    return currentJob.rules.allSatisfy({$0.validation.isValid})
                }
                
                return true
            }
        }
        
        static func == (lhs: Current, rhs: Current) -> Bool {
            let result = lhs.job == rhs.job
                && lhs.rule == rhs.rule
                && lhs.condition == rhs.condition
                && lhs.isConditionInEditMode == rhs.isConditionInEditMode
                && lhs.isConditionElementInEditMode == rhs.isConditionElementInEditMode
                && lhs.action == rhs.action
                && lhs.isActionInEditMode == rhs.isActionInEditMode
                && lhs.isActionElementInEditMode == rhs.isActionElementInEditMode
                && lhs.logJobId == rhs.logJobId
                && lhs.validationMessage == rhs.validationMessage
            
            return result
        }
    }
}

extension AppState {
    struct Views {
        var shownWindows: [String] = [String]()
        
        func isWindowShown(windowId: String) -> Bool {
            return shownWindows.count(where: {$0 == windowId}) > 0
        }
        
        mutating func addShownWindow(windowId: String) {
            shownWindows.append(windowId)
        }
        
        mutating func removeShownWindow(windowId: String) {
            shownWindows.removeAll(where: {$0 == windowId})
        }
    }
}

extension AppState {
    struct UserData : Settable, Equatable {
        var jobs = [Job]() {
            didSet {
                writeSettingsArray(newValues: jobs, key: Constants.settingsKeyJobs) }
        }
        
        static func == (lhs: UserData, rhs: UserData) -> Bool {
            let result = lhs.jobs == rhs.jobs
            
            return result
        }
        
        init() {
            let savedJobs: [Job]? = readSettingsArray(key: Constants.settingsKeyJobs)
            
            if (savedJobs != nil) {
                jobs = savedJobs!
            }
        }
    }
}
