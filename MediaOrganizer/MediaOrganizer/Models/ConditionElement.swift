//
//  ConditionElement.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import Foundation

class ConditionElement : ElementType {
    let id: UUID
    // MetadataType or ExpressionElementType
    let elementTypeId: Int
    let displayText: String
    var settingType: ElementValueType
    var selectedDateFormatType: DateFormatType?
    // StringOperatorType or NumberAndDateOperatorType
    var selectedOperatorTypeId: Int?
    var value: ConditionValue
    var fileMetadata: [MetadataType: Any?] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case elementTypeId
        case displayText
        case settingType
        case selectedDateFormatType
        case selectedOperatorTypeId
        case value
    }
    
    private static let valueTypesMap = [
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
        self.settingType = ConditionElement.valueTypesMap[elementTypeId] ?? .text
        self.value = .string(String())
    }
    
    func hasValue() -> Bool {
        guard MetadataType(rawValue: elementTypeId) != nil
        else {
            return true
        }
        
        return value.hasValue()
    }
    
    func clone(withValue: Bool = false) -> any ElementType {
        let result = ConditionElement(
            elementTypeId: self.elementTypeId,
            displayText: self.displayText)
        
        if withValue {
            result.settingType = self.settingType
            result.selectedDateFormatType = self.selectedDateFormatType
            result.selectedOperatorTypeId = self.selectedOperatorTypeId
            result.value = self.value
        }
        
        return result
    }
    
    func copyValues(other: ConditionElement) {
        other.settingType = self.settingType
        other.selectedDateFormatType = self.selectedDateFormatType
        other.selectedOperatorTypeId = self.selectedOperatorTypeId
        other.value = self.value
    }
    
    static func == (lhs: ConditionElement, rhs: ConditionElement) -> Bool {
        return lhs.id == rhs.id
    }
}
