//
//  RuleServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol RuleServiceType : ServiceBaseType {
    func createRule()
    func addRule()
    func updateRule()
    func isCurrentRule(ruleId: UUID) -> Bool
    func resetCurrentRule()
    func removeCurrentRule()
}
