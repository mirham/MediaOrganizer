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
    
    func toString(fileMetadata: [MetadataType: Any?]) -> String? {
        let dateFormatter = settingType == .date ? DateFormatter() : nil
        
        switch elementTypeId {
            case ElementType.slash.id:
                return Constants.slash
            case ElementType.customDate.id:
                guard customDate != nil && selectedFormatTypeId != nil else { return nil }
                
                dateFormatter!.dateFormat = DateFormatType(rawValue: selectedFormatTypeId!)!.formula
                return dateFormatter!.string(from: customDate!)
            case ElementType.customText.id:
                return customText
            case MetadataType.fileName.id:
                return fileMetadata[MetadataType.fileName] as? String
            case MetadataType.fileExtension.id:
                let extensionWithoutDot = fileMetadata[MetadataType.fileExtension] as? String
                return extensionWithoutDot == nil ? nil : "." + extensionWithoutDot!
            case MetadataType.fileDateCreated.id:
                guard let fileDateCreared = fileMetadata[MetadataType.fileDateCreated] as? Date else { return nil }
                
                dateFormatter!.dateFormat = DateFormatType(rawValue: selectedFormatTypeId!)!.formula
                return dateFormatter!.string(from: fileDateCreared)
            case MetadataType.fileDateModified.id:
                guard let fileDateModified = fileMetadata[MetadataType.fileDateModified] as? Date else { return nil }
                
                dateFormatter!.dateFormat = DateFormatType(rawValue: selectedFormatTypeId!)!.formula
                return dateFormatter!.string(from: fileDateModified)
            case MetadataType.metadataDateOriginal.id:
                guard let metadataDateOriginal = fileMetadata[MetadataType.metadataDateOriginal] as? Date else { return nil }
                
                dateFormatter!.dateFormat = DateFormatType(rawValue: selectedFormatTypeId!)!.formula
                return dateFormatter!.string(from: metadataDateOriginal)
            case MetadataType.metadataDateDigitilized.id:
                guard let metadataDateDigitilized = fileMetadata[MetadataType.metadataDateDigitilized] as? Date else { return nil }
                
                dateFormatter!.dateFormat = DateFormatType(rawValue: selectedFormatTypeId!)!.formula
                return dateFormatter!.string(from: metadataDateDigitilized)
            case MetadataType.metadataCameraModel.id:
                return fileMetadata[MetadataType.metadataCameraModel] as? String
            case MetadataType.metadataPixelXDimention.id:
                return fileMetadata[MetadataType.metadataPixelXDimention] as? String
            case MetadataType.metadataPixelYDimention.id:
                return fileMetadata[MetadataType.metadataPixelYDimention] as? String
            case MetadataType.metadataLatitude.id:
                return fileMetadata[MetadataType.metadataLatitude] as? String
            case MetadataType.metadataLongitude.id:
                return fileMetadata[MetadataType.metadataLongitude] as? String
            default:
                return nil
        }
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
