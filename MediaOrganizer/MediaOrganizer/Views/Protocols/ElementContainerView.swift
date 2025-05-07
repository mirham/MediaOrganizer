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
    
    private static var customizationMap: [Int: Bool] { [
        ActionType.rename.id: true,
        ActionType.copyToFolder.id: true,
        ActionType.moveToFolder.id: true,
        ConditionType.cIf.id: true,
        ConditionType.cElseIf.id: true
    ] }

    private static var elementOptionsMap: [Int: ElementOptions] { [
        OptionalElementType.slash.id:
            defaultElementOptions,
        OptionalElementType.customDate.id:
            ElementOptions(
                icon: nil,
                background: Color(hex: Constants.colorHexCustomElement),
                valueType: ElementValueType.date,
                hasFormula: true,
                editable: true),
        OptionalElementType.customText.id:
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
                hasFormula: false,
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
                editable: false),
        ActionType.rename.id:
            ElementOptions(
                icon: nil,
                background: Color.blue,
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false
            ),
        ActionType.copyToFolder.id:
            ElementOptions(
                icon: nil,
                background: Color.blue,
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false
            ),
        ActionType.moveToFolder.id:
            ElementOptions(
                icon: nil,
                background: Color.blue,
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false
            ),
        ActionType.skip.id:
            ElementOptions(
                icon: nil,
                background: Color.gray,
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false
            ),
        ActionType.delete.id:
            ElementOptions(
                icon: nil,
                background: Color.red,
                valueType: ElementValueType.text,
                hasFormula: false,
                editable: false
            )]
    }
    
    private static var optionalElementsMap: [Int: Bool] { [
        ActionType.rename.id: true,
        ActionType.copyToFolder.id: true,
        ActionType.moveToFolder.id: true
    ] }
    
    func getCustomizationAbilityByTypeId(typeId: Int) -> Bool {
        let result: Bool = Self.customizationMap[typeId] ?? false
        
        return result
    }
    
    func getElementOptionsByTypeId(typeId: Int) -> ElementOptions {
        let result: ElementOptions = Self.elementOptionsMap[typeId] ?? Self.defaultElementOptions
        
        return result
    }
    
    func getOptionalElements<T: ElementType>(typeId: Int) -> [DraggableElement<T>] {
        var result = [DraggableElement<T>]()
        
        let areOptionalElementsAllowed: Bool = Self.optionalElementsMap[typeId] ?? false
        guard areOptionalElementsAllowed else { return result }
        
        var optionalElements = [T]()
        
        for elementCase in OptionalElementType.allCases {
            let elementInfo = T.init(
                elementTypeId: elementCase.id,
                displayText: elementCase.description
            )
            optionalElements.append(elementInfo)
        }
        
        if typeId == ActionType.copyToFolder.id || typeId == ActionType.moveToFolder.id {
            for optionalElement in optionalElements {
                let actionElement = DraggableElement(element: optionalElement)
                result.append(actionElement)
            }
        }
        
        if typeId == ActionType.rename.id {
            for optionalElement in optionalElements.filter({ $0.elementTypeId != OptionalElementType.slash.id }) {
                let actionElement = DraggableElement(element: optionalElement)
                result.append(actionElement)
            }
        }
        
        return result
    }
}
