//
//  MetadataNumberStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 04.06.2025.
//

struct MetadataNumberStrategy : ElementStrategy {
    let typeKey: Int
    let metadataKey: MetadataType
    
    func elementAsString(context: ActionElement) -> String? {
        context.fileMetadata[metadataKey] as? String
    }
    
    func checkCondition(context: ConditionElement) -> Bool {
        guard let operatorTypeId = context.selectedOperatorTypeId,
              let metadataType = MetadataType(rawValue: context.elementTypeId),
              let metadataValue = context.fileMetadata[metadataType]
        else {
            return false
        }
        
        guard let operatorType = NumberAndDateOperatorType(rawValue: operatorTypeId)
        else {
            return false
        }
        
        let metadataIntValue = metadataValue as? Int
        let metadataDoubleValue = metadataValue as? Double
        
        guard metadataIntValue != nil || metadataDoubleValue != nil else { return false}
        guard context.value.intValue != nil || context.value.doubleValue != nil else { return false }
        
        let conditionIntValue = context.value.intValue
        let conditionDoubleValue = context.value.doubleValue
        
        if let metadataInt = metadataIntValue,
           let conditionInt = conditionIntValue {
            switch operatorType {
                case .equals: return metadataInt == conditionInt
                case .notEquals: return metadataInt != conditionInt
                case .greater: return metadataInt > conditionInt
                case .less: return metadataInt < conditionInt
                case .greaterOrEquals: return metadataInt >= conditionInt
                case .lessOrEquals: return metadataInt <= conditionInt
            }
        }
        
        if let metadataDouble = metadataDoubleValue,
           let conditionDouble = conditionDoubleValue {
            switch operatorType {
                case .equals: return metadataDouble == conditionDouble
                case .notEquals: return metadataDouble != conditionDouble
                case .greater: return metadataDouble > conditionDouble
                case .less: return metadataDouble < conditionDouble
                case .greaterOrEquals: return metadataDouble >= conditionDouble
                case .lessOrEquals: return metadataDouble <= conditionDouble
            }
        }
        
        return false
    }
}
