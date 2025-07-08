//
//  ValidationService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.07.2025.
//

import Foundation

protocol ValidationServiceType {
    func isValidString(input: String) -> ValidationResult
    func isValidInt(input: Int, dateFormatType: DateFormatType?) -> ValidationResult
    func isValidDate(input: Date) -> ValidationResult
    func isValidDouble(input: Double, metadataType: MetadataType?) -> ValidationResult
}
