//
//  CustomTextStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


struct CustomTextStrategy : ElementStrategy {
    let typeKey = ElementType.customText.rawValue
    
    func elementAsString(context: Element) -> String? {
        context.customText
    }
}
