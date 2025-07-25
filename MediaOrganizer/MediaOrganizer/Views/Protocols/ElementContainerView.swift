//
//  ElementContainerView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.10.2024.
//

import SwiftUI

protocol ElementContainerView: ColorThemeSupportedView {}

extension ElementContainerView {
    private static var defaultElementOptions: ElementOptions { ElementOptions(
        icon: nil,
        background: Color(.gray),
        hasFormula: false,
        editableInAction: false,
        editableInCondition: false,
        elementValueType: ElementValueType.text)
    }
    
    private static var defaultExpressionElementOptions: ElementOptions { ElementOptions(
        icon: nil,
        background: Color(hex: Constants.colorHexExpressionElement),
        hasFormula: false,
        editableInAction: false,
        editableInCondition: false,
        elementValueType: ElementValueType.text)
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
                hasFormula: true,
                editableInAction: true,
                editableInCondition: false,
                elementValueType: .date),
        OptionalElementType.customText.id:
            ElementOptions(
                icon: nil,
                background: Color(hex: Constants.colorHexCustomElement),
                hasFormula: false,
                editableInAction: true,
                editableInCondition: false,
                elementValueType: .text),
        MetadataType.fileName.id:
            ElementOptions(
                icon: Image(.file),
                background: Color(hex: Constants.colorHexFileElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .text,
                conditionValueType: .string),
        MetadataType.fileExtension.id:
            ElementOptions(
                icon: Image(.file),
                background: Color(hex: Constants.colorHexFileElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .text,
                conditionValueType: .string),
        MetadataType.fileDateCreated.id:
            ElementOptions(
                icon: Image(.file),
                background: Color(hex: Constants.colorHexFileElement),
                hasFormula: true,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .date,
                conditionValueType: .date),
        MetadataType.fileDateModified.id:
            ElementOptions(
                icon: Image(.file),
                background: Color(hex: Constants.colorHexFileElement),
                hasFormula: true,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .date,
                conditionValueType: .date),
        MetadataType.metadataDateOriginal.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: true,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .date,
                conditionValueType: .date),
        MetadataType.metadataDateDigitilized.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: true,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .date,
                conditionValueType: .date),
        MetadataType.metadataCameraModel.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .text,
                conditionValueType: .string),
        MetadataType.metadataPixelXDimention.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .number,
                conditionValueType: .int),
        MetadataType.metadataPixelYDimention.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .number,
                conditionValueType: .int),
        MetadataType.metadataLatitude.rawValue:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .number,
                conditionValueType: .double),
        MetadataType.metadataLongitude.id:
            ElementOptions(
                icon: Image(.exificon),
                background: Color(hex: Constants.colorHexExifElement),
                hasFormula: false,
                editableInAction: false,
                editableInCondition: true,
                elementValueType: .number,
                conditionValueType: .double),
        ActionType.rename.id:
            ElementOptions(
                icon: nil,
                background: Color.blue,
                hasFormula: false,
                editableInAction: false,
                editableInCondition: false,
                elementValueType: ElementValueType.text
            ),
        ActionType.copyToFolder.id:
            ElementOptions(
                icon: nil,
                background: Color.blue,
                hasFormula: false,
                editableInAction: false,
                editableInCondition: false,
                elementValueType: ElementValueType.text
            ),
        ActionType.moveToFolder.id:
            ElementOptions(
                icon: nil,
                background: Color.blue,
                hasFormula: false,
                editableInAction: false,
                editableInCondition: false,
                elementValueType: ElementValueType.text
            ),
        ActionType.skip.id:
            ElementOptions(
                icon: nil,
                background: Color.gray,
                hasFormula: false,
                editableInAction: false,
                editableInCondition: false,
                elementValueType: ElementValueType.text
            ),
        ActionType.delete.id:
            ElementOptions(
                icon: nil,
                background: Color.red,
                hasFormula: false,
                editableInAction: false,
                editableInCondition: false,
                elementValueType: ElementValueType.text
            ),
        ExpressionElementType.and.id:
            defaultExpressionElementOptions,
        ExpressionElementType.or.id:
            defaultExpressionElementOptions,
        ExpressionElementType.leftParen.id:
            defaultExpressionElementOptions,
        ExpressionElementType.rightParen.id:
            defaultExpressionElementOptions,
        ]
    }
    
    private static var optionalElementsMap: [Int: Bool] { [
        ActionType.rename.id: true,
        ActionType.copyToFolder.id: true,
        ConditionType.cIf.id: true,
        ConditionType.cElseIf.id: true
    ] }
    
    func getCustomizationAbilityByTypeId(typeId: Int) -> Bool {
        let result: Bool = Self.customizationMap[typeId] ?? false
        
        return result
    }
    
    func getElementOptionsByTypeId(typeId: Int, colorScheme: ColorScheme) -> ElementOptions {
        var result: ElementOptions = Self.elementOptionsMap[typeId] ?? Self.defaultElementOptions
        
        switch colorScheme {
            case .dark:
                result.background = result.background.opacity(0.6)
            case .light:
                result.background = result.background.opacity(0.3)
            @unknown default:
                break
        }
        
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
        
        if typeId == ConditionType.cIf.id || typeId == ConditionType.cElseIf.id {
            for elementCase in ExpressionElementType.allCases {
                let element = T.init(
                    elementTypeId: elementCase.id,
                    displayText: elementCase.description
                )
                let conditionElement = DraggableElement(element: element)
                result.append(conditionElement)
            }
        }
        
        return result
    }
    
    func getConditionFormatDescription(
        conditionValueType: ConditionValueType?,
        selectedDateFormatTypeId: Int?) -> String {
        guard conditionValueType == .date
        else { return String() }
        
        let dateFormatType = selectedDateFormatTypeId == nil
            ? DateFormatType.asIs
            : DateFormatType.init(rawValue: selectedDateFormatTypeId!)
        
        guard dateFormatType != nil else { return String() }
        
        let result = " (\(dateFormatType!.description.firstLowercased))"
        
        return result
    }
    
    func getOperatorDescription(
        conditionValueType: ConditionValueType?,
        selectedOperatorTypeId: Int?) -> String {
        switch conditionValueType {
            case .string:
                return selectedOperatorTypeId == nil
                    ? StringOperatorType.equals.description
                    : StringOperatorType.init(rawValue: selectedOperatorTypeId!)?.description
                ?? String()
            case .int, .double, .date:
                return selectedOperatorTypeId == nil
                    ? NumberAndDateOperatorType.equals.description
                    : NumberAndDateOperatorType.init(rawValue: selectedOperatorTypeId!)?.description
                ?? String()
            default:
                return String()
        }
    }
}
