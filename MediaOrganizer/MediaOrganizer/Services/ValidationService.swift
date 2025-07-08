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
}
