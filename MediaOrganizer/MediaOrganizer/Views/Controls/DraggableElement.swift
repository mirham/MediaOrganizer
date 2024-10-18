//
//  DraggableElement.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 19.09.2024.
//

import SwiftUI

struct DraggableElement: Equatable, Identifiable {
    let id: UUID
    let element: Element
    let dateCreated: Date
    
    init(element: Element) {
        self.id = UUID()
        self.element = element
        self.dateCreated = Date()
    }
    
    func clone() -> DraggableElement {
        let clonedElement = element.clone()
        let result = DraggableElement(element: clonedElement)
        
        return result
    }
}

