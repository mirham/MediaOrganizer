//
//  ElementStrategyFactory.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class ElementStrategyFactory : ElementStrategyFactoryType {
    func getStrategy(elementTypeKey: Int) -> (any ElementStrategy)? {
        let result = Container.shared.elementStrategies()
            .first(where: {$0.typeKey == elementTypeKey})
        
        return result
    }
}
