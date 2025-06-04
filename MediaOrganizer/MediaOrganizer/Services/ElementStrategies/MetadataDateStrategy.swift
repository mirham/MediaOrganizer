//
//  MetadataDateStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

import Foundation

struct MetadataDateStrategy : ElementStrategy {
    let typeKey: Int
    let metadataKey: MetadataType
    
    func elementAsString(context: ActionElement) -> String? {
        guard let date = context.fileMetadata[metadataKey] as? Date,
              let dateFormatType = context.selectedDateFormatType else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatType.formula
        let result = dateFormatter.string(from: date)
        
        return result
    }
    
    func checkCondition(context: ConditionElement) -> Bool {
        guard let operatorTypeId = context.selectedOperatorTypeId,
              let metadataType = MetadataType(rawValue: context.elementTypeId),
              let metadataValue = context.fileMetadata[metadataType],
              let dateFormatType = context.selectedDateFormatType else {
            return false
        }
        
        guard let operatorType = NumberAndDateOperatorType(rawValue: operatorTypeId) else { return false }
        
        let metadataDateValue = metadataValue as? Date
        
        guard metadataDateValue != nil else { return false}
        guard context.value.intValue != nil || context.value.dateValue != nil else { return false }
        
        let conditionIntValue = context.value.intValue
        let conditionDateValue = context.value.dateValue
        let calendar = Calendar.current
        var metadataDateValueComponent: Int?
        
        if let dateValue = metadataDateValue {
            switch dateFormatType {
                case .fourDigitYear:
                    metadataDateValueComponent = calendar.component(.year, from: dateValue)
                case .oneOrTwoDigitMonth:
                    metadataDateValueComponent = calendar.component(.month, from: dateValue)
                case .oneOrTwoDigitDay:
                    metadataDateValueComponent = calendar.component(.day, from: dateValue)
                case .oneOrTwoDigitHour24:
                    metadataDateValueComponent = calendar.component(.hour, from: dateValue)
                case .oneOrTwoDigitMinute:
                    metadataDateValueComponent = calendar.component(.minute, from: dateValue)
                case .oneOrTwoDigitSecond:
                    metadataDateValueComponent = calendar.component(.second, from: dateValue)
                default:
                    metadataDateValueComponent = nil
            }
        }
        
        if let dateComponent = metadataDateValueComponent, let intValue = conditionIntValue {
            switch operatorType {
                case .equals: return dateComponent == intValue
                case .notEquals: return dateComponent != intValue
                case .greater: return dateComponent > intValue
                case .less: return dateComponent < intValue
                case .greaterOrEquals: return dateComponent >= intValue
                case .lessOrEquals: return dateComponent <= intValue
            }
        }
        
        if let dateAsIs = metadataDateValue, let dateValue = conditionDateValue {
            switch operatorType {
                case .equals: return dateAsIs == dateValue
                case .notEquals: return dateAsIs != dateValue
                case .greater: return dateAsIs > dateValue
                case .less: return dateAsIs < dateValue
                case .greaterOrEquals: return dateAsIs >= dateValue
                case .lessOrEquals: return dateAsIs <= dateValue
            }
        }
        
        return false
    }
}
