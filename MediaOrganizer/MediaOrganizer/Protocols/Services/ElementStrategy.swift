//
//  ActionStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol ElementStrategy {
    var typeKey : Int { get }
    
    func elementAsString(context: ActionElement) -> String?
}
