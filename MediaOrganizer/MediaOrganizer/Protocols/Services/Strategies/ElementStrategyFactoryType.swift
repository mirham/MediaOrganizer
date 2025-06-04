//
//  ElementStrategyFactoryType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol ElementStrategyFactoryType {
    func getStrategy(elementTypeKey: Int) -> ElementStrategy?
}
