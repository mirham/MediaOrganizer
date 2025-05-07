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
