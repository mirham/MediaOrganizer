//
//  Element.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

protocol Element: Codable, Equatable, Identifiable {
    var elementTypeId: Int { get }
    var displayText: String { get }
    func clone() -> any Element
}
