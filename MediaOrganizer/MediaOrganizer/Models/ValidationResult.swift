//
//  ValidationResult.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 08.07.2025.
//

struct ValidationResult {
    let isValid: Bool
    let message: String?
    
    init() {
        self.isValid = true
        self.message = nil
    }
    
    init(message: String) {
        self.isValid = false
        self.message = message
    }
}
