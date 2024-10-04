//
//  ElementInfo.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import Foundation

class ElementInfo : Codable, Equatable {
    var id = UUID()
    let elementTypeId: Int
    let displayText: String
    let settingType: ElementValueType?
    var selectedTypeId: Int?
    var customDate: Date?
    var customText: String?
    
    init(elementTypeId: Int, displayText: String, settingType: ElementValueType?) {
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
}
