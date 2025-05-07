//
//  DraggableElement.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 19.09.2024.
//

import SwiftUI

struct DraggableElement<T: ElementType> : Equatable, Identifiable {
    let id: UUID
    let element: T
    let dateCreated: Date
    
    init(element: T) {
        self.id = UUID()
        self.element = element
        self.dateCreated = Date()
    }
    
    func clone() -> DraggableElement {
        let clonedElement = element.clone()
        let result = DraggableElement(element: clonedElement as! T)
        
        return result
    }
}

