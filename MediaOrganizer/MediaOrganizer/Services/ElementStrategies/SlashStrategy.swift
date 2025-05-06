//
//  SlashStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

struct SlashStrategy: ElementStrategy {    
    var typeKey = ElementType.slash.rawValue
    
    func elementAsString(context: Element) -> String? {
        Constants.slash
    }
}
