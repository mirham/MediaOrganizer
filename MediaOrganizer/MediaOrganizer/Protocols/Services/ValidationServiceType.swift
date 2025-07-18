//
//  ValidationService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.07.2025.
//

import Foundation

protocol ValidationServiceType {
    func isValidString(input: String, isArray: Bool) -> ValidationResult<String>
    func isValidInt(input: Int, dateFormatType: DateFormatType?) -> ValidationResult<Int>
    func isValidDate(input: Date) -> ValidationResult<Date>
    func isValidDouble(input: Double, metadataType: MetadataType?) -> ValidationResult<Double>
    func isValidFilename(input: String) -> ValidationResult<String>
    func isValidFolderPath(input: String, parentFolderPathLength: Int) -> ValidationResult<String>
    func areValidActions(actions: [Action]) -> ValidationResult<[Action]>
    func areValidConditions(conditions: [Condition]) -> ValidationResult<[Condition]>
}
