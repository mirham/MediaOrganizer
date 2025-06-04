//
//  CustomTextStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Foundation

struct CustomTextStrategy : ElementStrategy {
    let typeKey = OptionalElementType.customText.rawValue
    
    func elementAsString(context: ActionElement) -> String? {
        context.customText
    }
    
    func checkCondition(context: ConditionElement) -> Bool {
        abort()
    }
}
