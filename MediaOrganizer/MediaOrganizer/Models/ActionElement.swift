//
//  ActionElement.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import Foundation

class ActionElement : ElementType {
    let id: UUID
    let elementTypeId: Int
    let displayText: String
    let settingType: ElementValueType
    var selectedFormatTypeId: Int?
    var customDate: Date?
    var customText: String?
    var fileMetadata: [MetadataType: Any?] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case elementTypeId
        case displayText
        case settingType
        case selectedFormatTypeId
        case customDate
        case customText
    }
    
    private static let valueTypesMap = [
        OptionalElementType.slash.id: ElementValueType.text,
        OptionalElementType.customDate.id: ElementValueType.date,
        OptionalElementType.customText.id: ElementValueType.text,
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
    
    required init(elementTypeId: Int, displayText: String) {
        self.id = UUID()
        self.elementTypeId = elementTypeId
        self.displayText = displayText
        self.settingType = ActionElement.valueTypesMap[elementTypeId] ?? .text
        self.selectedFormatTypeId = nil
        self.customDate = nil
        self.customText = nil
    }
    
    func clone() -> any ElementType {
        let result = ActionElement(
            elementTypeId: self.elementTypeId,
            displayText: self.displayText)
        
        return result
    }
    
    static func == (lhs: ActionElement, rhs: ActionElement) -> Bool {
        return lhs.id == rhs.id
    }
}
