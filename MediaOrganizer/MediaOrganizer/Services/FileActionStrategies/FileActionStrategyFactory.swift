//
//  FileActionStrategyFactory.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class FileActionStrategyFactory : FileActionStrategyFactoryType {
    func getStrategy(actionType: ActionType) ->  FileActionStrategy? {
        let result = Container.shared.fileActionStrategies()
            .first(where: { $0.actionType == actionType })
        
        return result
    }
}
