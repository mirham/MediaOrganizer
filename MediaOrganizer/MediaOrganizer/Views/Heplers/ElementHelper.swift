//
//  ElementHelper.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import SwiftUI

class ElementHelper {
    private static let elementOptionsMap = [
        ElementType.slash.id:
            ElementOptions(
                icon: nil,
                backgound: Color(.gray),
                valueType: ElementValueType.text,
                editable: false),
        ElementType.customDate.id:
            ElementOptions(
                icon: nil,
                backgound: Color(hex: Constants.colorHexCustomElement),
                valueType: ElementValueType.date,
                editable: false),
        ElementType.customText.id:
            ElementOptions(
                icon: nil,
                backgound: Color(hex: Constants.colorHexCustomElement),
                valueType: ElementValueType.text,
                editable: true),
        MetadataType.fileName.id:
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                backgound: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.text,
                editable: false),
          MetadataType.fileDateCreated.id :
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                backgound: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.date,
                editable: false),
          MetadataType.fileDateModified.id :
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                backgound: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.date,
                editable: false),
          MetadataType.exifDateOriginal.id :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.date,
                editable: false),
          MetadataType.exifDateDigitilized.id :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.date,
                editable: false),
          MetadataType.exifCameraModel.id :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.text,
                editable: false),
          MetadataType.exifPixelXDimention.id :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                editable: false),
          MetadataType.exifPixelYDimention.id :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                editable: false),
          MetadataType.exifLatitude.rawValue :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                editable: false),
          MetadataType.exifLongitude.id :
            ElementOptions(
                icon: Image(.exificon),
                backgound: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                editable: false)
    ];
    
    static func getElementOptionsByTypeId(typeId: Int) -> ElementOptions? {
        let result: ElementOptions? = elementOptionsMap[typeId]
        
        return result
    }
}

struct ElementOptions {
    let icon: Image?
    let backgound: Color
    let valueType: ElementValueType
    let editable: Bool
}
