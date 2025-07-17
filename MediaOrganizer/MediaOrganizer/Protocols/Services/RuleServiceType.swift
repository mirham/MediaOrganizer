//
//  RuleServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Foundation

protocol RuleServiceType : ServiceBaseType {
    func createRule()
    func doesCurrentRuleExist() -> Bool
    func isCurrentRule(ruleId: UUID) -> Bool
    func getRuleIndexByRuleId(ruleId: UUID) -> Int?
    func addRule()
    func duplicateRule()
    func updateRule()
    func moveRuleUp()
    func moveRuleDown()
    func applyRule(rule:Rule, fileInfo: MediaFileInfo) throws -> [FileAction]
    func validateRule(rule: Rule?)
    func resetCurrentRule()
    func removeCurrentRule()
}
