//
//  CustomDateStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Foundation

struct CustomDateStrategy : ElementStrategy {
    let typeKey = OptionalElementType.customDate.rawValue
    
    func elementAsString(context: ActionElement) -> String? {
        guard let date = context.customDate,
              let dateFormatType = context.selectedDateFormatType else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatType.formula
        let result = dateFormatter.string(from: date)
        
        return result
    }
    
    func checkCondition(context: ConditionElement) -> Bool {
        abort()
    }
}
