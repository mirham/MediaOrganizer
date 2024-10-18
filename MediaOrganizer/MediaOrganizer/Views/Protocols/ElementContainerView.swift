//
//  ElementContainerView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.10.2024.
//

import SwiftUI

protocol ElementContainerView: View {}

extension ElementContainerView {
    private static var defaultElementOptions: ElementOptions { ElementOptions(
        icon: nil,
        background: Color(.gray),
        valueType: ElementValueType.text,
        hasFormula: false,
        editable: false)
    }

    private static var elementOptionsMap: [Int: ElementOptions] { [
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
        MetadataType.fileExtension.id:
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                background: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false),
        MetadataType.fileDateCreated.id:
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                background: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
        MetadataType.fileDateModified.id:
            ElementOptions(
                icon: Image(systemName: Constants.iconFile),
                background: Color(hex: Constants.colorHexFileElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
        MetadataType.metadataDateOriginal.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
        MetadataType.metadataDateDigitilized.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: false),
        MetadataType.metadataCameraModel.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false),
        MetadataType.metadataPixelXDimention.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: true,
                editable: false),
        MetadataType.metadataPixelYDimention.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: false,
                editable: false),
        MetadataType.metadataLatitude.rawValue:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: false,
                editable: false),
        MetadataType.metadataLongitude.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                valueType: ElementValueType.number,
                hasFormula: false,
                editable: false) ]
    }
    
    func getElementOptionsByTypeId(typeId: Int) -> ElementOptions {
        let result: ElementOptions = Self.elementOptionsMap[typeId] ?? Self.defaultElementOptions
        
        return result
    }
}
