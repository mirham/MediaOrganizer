//
//  ValidationService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.07.2025.
//

import Foundation

class ValidationService: ServiceBase, ValidationServiceType {
    private let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter();
        dateFormatter.dateFormat = Constants.defaultValidationDateFormat
        
        super.init()
    }
    
    func isValidString(input: String) -> ValidationResult {
        let isValid = input.count >= Constants.stringMinLength
            && input.count <= Constants.stringMaxLength
        
        return isValid
            ? ValidationResult()
            : ValidationResult(message: Constants.vmStringLengthIsIncorrect)
    }
    
    func isValidInt(input: Int, dateFormatType: DateFormatType?) -> ValidationResult {
        var result: ValidationResult
        
        if dateFormatType == nil {
            let isValid = input >= Constants.resolutionMinValue
                && input <= Constants.resolutionMaxValue
            result = isValid
                ? ValidationResult()
                : ValidationResult(message: Constants.vmResolutionIsIncorrect)
        }
        else {
            switch dateFormatType {
                case .fourDigitYear:
                    let isValid = input >= Constants.yearMinValue
                        && input <= Constants.yearMaхValue
                    result = isValid
                        ? ValidationResult()
                        : ValidationResult(message: Constants.vmYearIsIncorrect)
                    
                    break
                case .oneOrTwoDigitMonth:
                    let isValid = input >= Constants.monthMinValue
                        && input <= Constants.monthMaхValue
                    result = isValid
                        ? ValidationResult()
                        : ValidationResult(message: Constants.vmMonthIsIncorrect)
                    
                    break
                case .oneOrTwoDigitDay:
                    let isValid = input >= Constants.dayMinValue
                        && input <= Constants.dayMaхValue
                    result = isValid
                        ? ValidationResult()
                        : ValidationResult(message: Constants.vmDayIsIncorrect)
                    
                    break
                case .oneOrTwoDigitHour24:
                    let isValid = input >= Constants.hourMinValue
                        && input <= Constants.hourMaхValue
                    result = isValid
                        ? ValidationResult()
                        : ValidationResult(message: Constants.vmHourIsIncorrect)
                    
                    break
                case .oneOrTwoDigitMinute:
                    let isValid = input >= Constants.minuteMinValue
                        && input <= Constants.minuteMaхValue
                    result = isValid
                        ? ValidationResult()
                        : ValidationResult(message: Constants.vmMinuteIsIncorrect)
                    
                    break
                case .oneOrTwoDigitSecond:
                    let isValid = input >= Constants.secondMinValue
                        && input <= Constants.secondMaхValue
                    result = isValid
                        ? ValidationResult()
                        : ValidationResult(message: Constants.vmSecondIsIncorrect)
                    
                    break
                default:
                    result = ValidationResult(message: Constants.vmNotSupportedValue)
                    
                    break
            }
        }
        
        return result
    }
    
    func isValidDate(input: Date) -> ValidationResult {
        guard let minDate = dateFormatter.date(from: Constants.dateMinValueString),
              let maxDate = dateFormatter.date(from: Constants.dateMaxValueString)
        else { return ValidationResult(message: Constants.vmNotSupportedValue) }
        
        let isValid = input >= minDate && input <= maxDate
        
        return isValid
            ? ValidationResult()
            : ValidationResult(message: Constants.vmDateIsIncorrect)
    }
    
    func isValidDouble(input: Double, metadataType: MetadataType?) -> ValidationResult {
        var result: ValidationResult
        
        switch metadataType {
            case .metadataLatitude:
                let isValid = input >= Constants.latitudeMinValue
                    && input <= Constants.latitudeMaxValue
                result = isValid
                    ? ValidationResult()
                    : ValidationResult(message: Constants.vmLatitudeIsIncorrect)
            case .metadataLongitude:
                let isValid = input >= Constants.longitudeMinValue
                    && input <= Constants.longitudeMaxValue
                result = isValid
                    ? ValidationResult()
                    : ValidationResult(message: Constants.vmLongitudeIsIncorrect)
            default:
                result = ValidationResult(message: Constants.vmNotSupportedValue)
                
                break
        }
        
        return result
    }
    
    func isValidFilename(input: String) -> ValidationResult {
        let invalidCharacters = CharacterSet(charactersIn: Constants.slash)
            .union(.controlCharacters)
            .union(.illegalCharacters)
            .union(.newlines)
        
        if input.isEmpty {
            return ValidationResult(message: Constants.vmEmptyFilename)
        }
        
        if input.unicodeScalars.contains(where: { invalidCharacters.contains($0) }) {
            return ValidationResult(message: Constants.vmInvalidCharactersFilename)
        }
        
        if input.utf16.count > 255 {
            return ValidationResult(message: Constants.vmTooLongFilename)
        }
        
        if input.hasPrefix(Constants.spaceShort) || input.hasSuffix(Constants.spaceShort) {
            return ValidationResult(message: Constants.vmFilenameStartsOrEndsWithSpace)
        }
        if input.hasSuffix(Constants.dot) {
            return ValidationResult(message: Constants.vmFilenameEndsWithDot)
        }
        
        if input.hasPrefix(Constants.dot) {
            return ValidationResult(message: Constants.vmFilenameStartsWithDot)
        }
        
        if !input.contains(Constants.dot)
            || input.hasSuffix(Constants.dot)
            || input.components(separatedBy: Constants.dot).last?.isEmpty == true {
            return ValidationResult(message: Constants.vmFilenameMustHaveExtension)
        }
        
        return ValidationResult()
    }
    
    func isValidFolderPath(input: String, parentFolderPathLength: Int) -> ValidationResult {
        /*if input.isEmpty {
            return ValidationResult(message: "Folder path cannot be empty.")
        }*/
        
        let invalidCharacters = CharacterSet(charactersIn: Constants.nullChar)
            .union(.controlCharacters)
            .union(.illegalCharacters)
            .union(.newlines)
        
        if input.unicodeScalars.contains(where: { invalidCharacters.contains($0) }) {
            return ValidationResult(message: Constants.vmInvalidCharactersFolderPath)
        }
        
        if input.contains(Constants.regexTwoSlashes) {
            return ValidationResult(message: Constants.vmFolderPathContainsMultipleSlashes)
        }
        
        if parentFolderPathLength + input.utf16.count > Constants.maxFolderPathLength {
            return ValidationResult(message: Constants.vmTooLongPath)
        }
        
        let pathComponents = input.components(separatedBy: Constants.slash).filter { !$0.isEmpty }
        
        /*if pathComponents.isEmpty && !input.hasPrefix(Constants.slash) {
            return ValidationResult(message: "Folder path is invalid or contains no components.")
        }*/
        
        for component in pathComponents {
            if component.utf16.count > Constants.maxFileNameLength {
                return ValidationResult(message: String(
                    format: Constants.vmTooLongPathComponent, component))
            }
            
            if component.hasPrefix(Constants.space) || component.hasSuffix(Constants.space) {
                return ValidationResult(message: String(
                    format: Constants.vmPathComponentStartsOrEndsWithSpace, component))
            }
            
            if component.hasSuffix(Constants.dot) {
                return ValidationResult(message: String(
                    format: Constants.vmPathComponentEndsWithDot, component))
            }
            
            if component.hasPrefix(Constants.dot) {
                return ValidationResult(message:String(
                    format: Constants.vmPathComponentStartsWithDot, component))
            }
        }
        
        // If all checks pass
        return ValidationResult()
    }
}
