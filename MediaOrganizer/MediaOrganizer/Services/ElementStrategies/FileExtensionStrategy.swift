//
//  FileExtensionStrategy.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


struct FileExtensionStrategy : ElementStrategy {
    let typeKey = MetadataType.fileExtension.rawValue
    
    func elementAsString(context: Element) -> String? {
        guard let extensionWithoutDot = context.fileMetadata[.fileExtension] as? String else {
            return nil
        }
        
        let result = "." + extensionWithoutDot
        
        return result
    }
}
