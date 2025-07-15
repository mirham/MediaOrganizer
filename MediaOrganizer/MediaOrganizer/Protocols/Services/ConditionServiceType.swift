//
//  ConditionServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//


import Foundation

protocol ConditionServiceType : ServiceBaseType {
    func addNewCondition()
    func isCurrentCondition(conditionId: UUID) -> Bool
    func applyConditions(conditions: [Condition], fileInfo: MediaFileInfo) throws -> Bool
    func replaceCondition(conditionId: UUID, condition: Condition)
    func removeConditionById(conditionId: UUID)
}
