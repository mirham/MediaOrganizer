//
//  CustomDateStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Foundation

struct CustomDateStrategy : ElementStrategy {
    let typeKey = ElementType.customDate.rawValue
    
    func elementAsString(context: Element) -> String? {
        guard let date = context.customDate,
              let formatTypeId = context.selectedFormatTypeId,
              let formatType = DateFormatType(rawValue: formatTypeId) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.formula
        let result = dateFormatter.string(from: date)
        
        return result
    }
}
