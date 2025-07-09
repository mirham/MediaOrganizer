//
//  ElementType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

protocol ElementType: Codable, Equatable, Identifiable {
    var elementTypeId: Int { get }
    var displayText: String { get }
    
    init(elementTypeId: Int, displayText: String)
    
    func clone(withValue: Bool) -> any ElementType
}
