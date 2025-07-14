//
//  ValidationResult.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.07.2025.
//

struct ValidationResult<T: Codable> {
    let isValid: Bool
    let message: String?
    let adjustedResult: T?
    
    init() {
        self.isValid = true
        self.message = nil
        self.adjustedResult = nil
    }
    
    init(adjustedResult: T) {
        self.isValid = true
        self.message = nil
        self.adjustedResult = adjustedResult
    }
    
    init(message: String) {
        self.isValid = false
        self.message = message
        self.adjustedResult = nil
    }
}
