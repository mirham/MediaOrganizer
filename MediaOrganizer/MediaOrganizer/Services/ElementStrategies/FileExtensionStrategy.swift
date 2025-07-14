//
//  FileExtensionStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//

struct FileExtensionStrategy : ElementStrategy {
    let typeKey = MetadataType.fileExtension.rawValue
    
    func elementAsString(context: ActionElement) -> String? {
        guard let extensionWithoutDot = context.fileMetadata[.fileExtension] as? String else {
            return nil
        }
        
        let result = Constants.dot + extensionWithoutDot
        
        return result
    }
    
    func checkCondition(context: ConditionElement) -> Bool {
        guard let operatorTypeId = context.selectedOperatorTypeId,
              let metadataType = MetadataType(rawValue: context.elementTypeId),
              let metadataValue = context.fileMetadata[metadataType] else {
            return false
        }
        
        guard let operatorType = StringOperatorType(rawValue: operatorTypeId) else { return false }
        
        if let metadataString = metadataValue as? String,
           let conditionString = context.value.stringValue {
            let metadataStringUpper = metadataString.uppercased()
            let conditionStringUpper = conditionString.uppercased()
            
            switch operatorType {
                case .equals: return metadataStringUpper == conditionStringUpper
                case .contains: return metadataStringUpper.contains(conditionStringUpper)
                case .notContains: return !metadataStringUpper.contains(conditionStringUpper)
                case .startsWith: return metadataStringUpper.hasPrefix(conditionStringUpper)
                case .endsWith: return metadataStringUpper.hasSuffix(conditionStringUpper)
                case .oIn: return metadataStringUpper.contains(conditionStringUpper)
            }
        }
        
        return false
    }
}
