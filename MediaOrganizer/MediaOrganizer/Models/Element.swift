//
//  Element.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import Foundation

class Element : Codable, Equatable {
    let id: UUID
    let elementTypeId: Int
    let displayText: String
    let settingType: ElementValueType
    var selectedFormatTypeId: Int?
    var customDate: Date?
    var customText: String?
    
    private static let valueTypesMap = [
        ElementType.slash.id: ElementValueType.text,
        ElementType.customDate.id: ElementValueType.date,
        ElementType.customText.id: ElementValueType.text,
        MetadataType.fileName.id: ElementValueType.text,
        MetadataType.fileExtension.id: ElementValueType.text,
        MetadataType.fileDateCreated.id: ElementValueType.date,
        MetadataType.fileDateModified.id: ElementValueType.date,
        MetadataType.metadataDateOriginal.id: ElementValueType.date,
        MetadataType.metadataDateDigitilized.id: ElementValueType.date,
        MetadataType.metadataCameraModel.id: ElementValueType.text,
        MetadataType.metadataPixelXDimention.id: ElementValueType.number,
        MetadataType.metadataPixelYDimention.id: ElementValueType.number,
        MetadataType.metadataLatitude.rawValue: ElementValueType.number,
        MetadataType.metadataLongitude.id: ElementValueType.number
    ];
    
    init(elementTypeId: Int, displayText: String) {
        self.id = UUID()
        self.elementTypeId = elementTypeId
        self.displayText = displayText
        self.settingType = Element.valueTypesMap[elementTypeId] ?? .text
        self.selectedFormatTypeId = nil
        self.customDate = nil
        self.customText = nil
    }
    
    func clone() -> Element {
        let result = Element(
            elementTypeId: self.elementTypeId,
            displayText: self.displayText)
        
        return result
    }
    
    static func == (lhs: Element, rhs: Element) -> Bool {
        return lhs.id == rhs.id
    }
}
