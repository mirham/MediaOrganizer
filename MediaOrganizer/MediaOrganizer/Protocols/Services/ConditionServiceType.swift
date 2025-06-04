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
    func applyConditions(conditions: [Condition], fileInfo: MediaFileInfo) -> Bool
    func removeConditionById(conditionId: UUID)
}
