//
//  ElementHelper.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import SwiftUI

class ElementHelper {
    private static let defaultElementOptions = ElementOptions(
        icon: nil,
        background: Color(.gray),
        valueType: ElementValueType.text,
        hasFormula: false,
        editable: false)
    
    private static let elementOptionsMap = [
        ElementType.slash.id:
            defaultElementOptions,
        ElementType.customDate.id:
            ElementOptions(
                icon: nil,
                background: Color(hex: Constants.colorHexCustomElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: true),
        ElementType.customText.id:
            ElementOptions(
                icon: nil,
                background: Color(hex: Constants.colorHexCustomElement),
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: true),
        MetadataType.fileName.id:
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                background: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false),
          MetadataType.fileDateCreated.id :
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                background: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
          MetadataType.fileDateModified.id :
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                background: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
          MetadataType.metadataDateOriginal.id :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
          MetadataType.metadataDateDigitilized.id :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
          MetadataType.metadataCameraModel.id :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false),
          MetadataType.metadataPixelXDimention.id :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: true,
                editable: false),
          MetadataType.metadataPixelYDimention.id :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: false,
                editable: false),
          MetadataType.metadataLatitude.rawValue :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: false,
                editable: false),
          MetadataType.metadataLongitude.id :
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: false,
                editable: false)
    ];
    
    private static let elementValueTypesMap = [
        ElementType.slash.id: ElementValueType.text,
        ElementType.customDate.id: ElementValueType.date,
        ElementType.customText.id: ElementValueType.text,
        MetadataType.fileName.id: ElementValueType.text,
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
    
    static func getElementOptionsByTypeId(typeId: Int) -> ElementOptions {
        let result: ElementOptions = elementOptionsMap[typeId] ?? defaultElementOptions
        
        return result
    }
    
    static func getElementValueTypeByTypeId(typeId: Int) -> ElementValueType {
        let result: ElementValueType = elementValueTypesMap[typeId] ?? .text
        
        return result
    }
}


