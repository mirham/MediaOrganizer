//
//  MetadataStringStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


struct MetadataStringStrategy : ElementStrategy {
    let typeKey: Int
    let metadataKey: MetadataType
    
    func elementAsString(context: ActionElement) -> String? {
        context.fileMetadata[metadataKey] as? String
    }
}
