//
//  ServiceBaseType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol ServiceBaseType {
    func doesCurrentJobExist() -> Bool
    func getCurrentJobId() -> UUID?
    func getJobIndexByJobId(jobId: UUID) -> Int?
    func doesCurrentRuleExist() -> Bool
    func getCurrentRuleId() -> UUID?
    func getRuleIndexByRuleId(ruleId: UUID) -> Int?
    func doesCurrentConditionExist() -> Bool
    func doesCurrentActionExist() -> Bool
}
