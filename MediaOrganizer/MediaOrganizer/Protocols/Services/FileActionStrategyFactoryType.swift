//
//  ActionStrategyFactory.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol FileActionStrategyFactoryType {
    func getStrategy(actionType: ActionType) -> FileActionStrategy?
}
