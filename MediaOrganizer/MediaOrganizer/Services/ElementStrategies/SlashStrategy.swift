//
//  SlashStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

struct SlashStrategy: ElementStrategy {    
    var typeKey = OptionalElementType.slash.rawValue
    
    func elementAsString(context: ActionElement) -> String? {
        Constants.slash
    }
}
