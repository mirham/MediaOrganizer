//
//  ElementService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation
import Factory

class ElementService : ElementServiceType {
    @Injected(\.elementStrategyFactory) private var elementStrategyFactory
    
    func elementAsString(element : ActionElement) -> String? {
        let elementStrategy = elementStrategyFactory
            .getStrategy(elementTypeKey: element.elementTypeId)
        let result = elementStrategy?.elementAsString(context: element) ?? nil
        
        return result
    }
}
