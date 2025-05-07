//
//  CustomTextStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


struct CustomTextStrategy : ElementStrategy {
    let typeKey = OptionalElementType.customText.rawValue
    
    func elementAsString(context: ActionElement) -> String? {
        context.customText
    }
}
