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
        var job: Job? = nil
        var rule: Rule? = nil
        var condition: Condition? = nil
        var isConditionInEditMode = false
        var isConditionElementInEditMode = false
        var action: Action? = nil
        var isActionInEditMode = false
        var isActionElementInEditMode = false
        var validationMessage: String? = nil
        
        var isDragAllowed: Bool { get { return !isConditionElementInEditMode && !isActionElementInEditMode } }
        
        func allowWindowClose() -> Bool {
            return !isActionInEditMode && !isConditionInEditMode
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
                && lhs.validationMessage == rhs.validationMessage
            
            return result
        }
    }
}

extension AppState {
    struct Views {
        var isJobsViewShown = false
        var isJobSettingsViewShown = false
        var isInfoViewShown = false
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
