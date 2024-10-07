//
//  DraggableElement.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 19.09.2024.
//

import SwiftUI

struct DraggableElement: Equatable, Identifiable {
    let id: UUID
    let elementInfo: ElementInfo
    let dateCreated: Date
    
    init(elementInfo: ElementInfo) {
        self.id = UUID()
        self.elementInfo = elementInfo
        self.dateCreated = Date()
    }
    
    func clone() -> DraggableElement {
        let elementInfo = elementInfo.clone()
        let result = DraggableElement(elementInfo: elementInfo)
        
        return result
    }
}

