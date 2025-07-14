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
        var result = dateFormatter.string(from: date)
        result = setupUsDateFormatIfNeeded(
            dateFormatType: context.selectedDateFormatType,
            input: result)
        
        return result
    }
    
    func checkCondition(context: ConditionElement) -> Bool {
        abort()
    }
    
    // MARK: Private functions
    
    private func setupUsDateFormatIfNeeded(
        dateFormatType: DateFormatType?,
        input: String) -> String {
        guard let dateFormatType = dateFormatType
        else { return input }
        
        switch dateFormatType {
            case .dateTimeUs, .dateUs, .monthAndDayUs:
                return input.withColonsInsteadSlashes
            default:
                return input
        }
    }
}
