//
//  ActionServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol ActionServiceType : ServiceBaseType {
    func removeActionById(actionId: UUID)
    func removeCurrentAction()
    func isCurrentAction(actionId: UUID) -> Bool
}
