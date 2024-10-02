//
//  DraggableElement.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 19.09.2024.
//

import SwiftUI

struct DraggableElement: Equatable {
    let id = UUID()
    let elementInfo: ElementInfo
    let dateCreated: Date
    
    init(elementInfo: ElementInfo) {
        self.elementInfo = elementInfo
        self.dateCreated = Date()
    }
    
    func clone() -> DraggableElement {
        let result = DraggableElement(elementInfo: self.elementInfo)
        
        return result
    }
}

