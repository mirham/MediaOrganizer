//
//  ConditionServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//


import Foundation

protocol ConditionServiceType : ServiceBaseType {
    func isCurrentCondition(conditionId: UUID) -> Bool
    func removeConditionById(conditionId: UUID)
    func removeCurrentCondition()
}
