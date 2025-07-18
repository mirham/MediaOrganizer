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
    let severity: ValidationSeverity?
    
    init() {
        self.isValid = true
        self.message = nil
        self.adjustedResult = nil
        self.severity = nil
    }
    
    init(adjustedResult: T) {
        self.isValid = true
        self.message = nil
        self.adjustedResult = adjustedResult
        self.severity = nil
    }
    
    init(message: String, severity: ValidationSeverity = .error) {
        self.isValid = false
        self.message = message
        self.adjustedResult = nil
        self.severity = severity
    }
}
