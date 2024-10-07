//
//  ElementInfo.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import Foundation

class ElementInfo : Codable, Equatable {
    let id: UUID
    let elementTypeId: Int
    let displayText: String
    let settingType: ElementValueType?
    var selectedTypeId: Int?
    var customDate: Date?
    var customText: String?
    
    var elementOptions: ElementOptions { get
        {
            return ElementHelper.getElementOptionsByTypeId(typeId: elementTypeId)
        }
    }
    
    init(elementTypeId: Int, displayText: String, settingType: ElementValueType?) {
        self.id = UUID()
        self.elementTypeId = elementTypeId
        self.displayText = displayText
        self.settingType = settingType
        self.selectedTypeId = nil
        self.customDate = nil
        self.customText = nil
    }
    
    static func == (lhs: ElementInfo, rhs: ElementInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    func clone() -> ElementInfo {
        let result = ElementInfo(
            elementTypeId: self.elementTypeId,
            displayText: self.displayText,
            settingType: self.settingType)
        
        return result
    }
}
