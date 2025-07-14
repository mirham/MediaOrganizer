//
//  DateFormatType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

enum DateFormatType : Int, CaseIterable, Identifiable, Codable, Equatable {
    var id: Int { return self.rawValue }
    
    case asIs = 0
    case dateEu = 1
    case dateUs = 2
    case dateTimeEu = 3
    case dateTimeUs = 4
    case monthAndDay = 5
    case monthAndDayUs = 6
    case fourDigitYear = 7
    case twoDigitYear = 8
    case twoDigitMonth = 9
    case oneOrTwoDigitMonth = 10
    case twoDigitDay = 11
    case oneOrTwoDigitDay = 12
    case twoDigitHour24 = 13
    case oneOrTwoDigitHour24 = 14
    case twoDigitHour12 = 15
    case oneOrTwoDigitHour12 = 16
    case twoDigitMinute = 17
    case oneOrTwoDigitMinute = 18
    case twoDigitSecond = 19
    case oneOrTwoDigitSecond = 20
    case amPm = 21
    
    var description: String {
        switch self {
            case .asIs: return "As is"
            case .dateEu: return "Date, EU"
            case .dateUs: return "Date, US"
            case .dateTimeEu: return "Date and time, EU"
            case .dateTimeUs: return "Date and time, US"
            case .monthAndDay: return "Month and day, EU"
            case .monthAndDayUs: return "Month and day, US"
            case .fourDigitYear: return "4-digit year"
            case .twoDigitYear: return "2-digit year"
            case .twoDigitMonth: return "2-digit month"
            case .oneOrTwoDigitMonth: return "1 or 2 digit month"
            case .twoDigitDay: return "2-digit day"
            case .oneOrTwoDigitDay: return "1 or 2 digit day"
            case .twoDigitHour24: return "2-digit hour, 24-hour format"
            case .oneOrTwoDigitHour24: return "1 or 2 digit hour, 24-hour format"
            case .twoDigitHour12: return "2-digit hour, 12-hour format"
            case .oneOrTwoDigitHour12: return "1 or 2 digit hour, 12-hour format"
            case .twoDigitMinute: return "2-digit minute"
            case .oneOrTwoDigitMinute: return "1 or 2 digit minute"
            case .twoDigitSecond: return "2-digit second"
            case .oneOrTwoDigitSecond: return "1 or 2 digit second"
            case .amPm: return "AM/PM, 12-hour format"
        }
    }
    
    var formula: String {
        switch self {
            case .asIs: return String()
            case .dateEu: return "dd.MM.yyyy"
            case .dateUs: return "MM/dd/yyyy"
            case .dateTimeEu: return "MM.dd.yyyy HH-mm-ss"
            case .dateTimeUs: return "MM/dd/yyyy HH-mm-ss"
            case .monthAndDay: return "MM.dd"
            case .monthAndDayUs: return "MM/dd"
            case .fourDigitYear: return "yyyy"
            case .twoDigitYear: return "yy"
            case .twoDigitMonth: return "MM"
            case .oneOrTwoDigitMonth: return "M"
            case .twoDigitDay: return "dd"
            case .oneOrTwoDigitDay: return "d"
            case .twoDigitHour24: return "HH"
            case .oneOrTwoDigitHour24: return "H"
            case .twoDigitHour12: return "hh"
            case .oneOrTwoDigitHour12: return "h"
            case .twoDigitMinute: return "mm"
            case .oneOrTwoDigitMinute: return "m"
            case .twoDigitSecond: return "ss"
            case .oneOrTwoDigitSecond: return "s"
            case .amPm: return "a"
        }
    }
    
    var example: String {
        switch self {
            case .asIs: return String()
            case .dateEu: return "05.01.2025"
            case .dateUs: return "01/05/2025"
            case .dateTimeEu: return "05.01.2025 09-01-05"
            case .dateTimeUs: return "01/05/2025 09-01-05"
            case .monthAndDay: return "05.01"
            case .monthAndDayUs: return "01/05"
            case .fourDigitYear: return "2025"
            case .twoDigitYear: return "25"
            case .twoDigitMonth: return "01"
            case .oneOrTwoDigitMonth: return "1"
            case .twoDigitDay: return "05"
            case .oneOrTwoDigitDay: return "5"
            case .twoDigitHour24: return "09"
            case .oneOrTwoDigitHour24: return "9"
            case .twoDigitHour12: return "09"
            case .oneOrTwoDigitHour12: return "9"
            case .twoDigitMinute: return "01"
            case .oneOrTwoDigitMinute: return "1"
            case .twoDigitSecond: return "05"
            case .oneOrTwoDigitSecond: return "5"
            case .amPm: return "AM"
        }
    }
    
    static func selectForAction() -> [DateFormatType] {
        let result = DateFormatType.allCases.filter { $0 != .asIs }
        
        return result
    }
    
    static func selectForCondition() -> [DateFormatType] {
        let result = DateFormatType.allCases.filter {
            $0 == .asIs
            || $0 == .fourDigitYear
            || $0 == .oneOrTwoDigitMonth
            || $0 == .oneOrTwoDigitDay
            || $0 == .oneOrTwoDigitHour24
            || $0 == .oneOrTwoDigitMinute
            || $0 == .oneOrTwoDigitSecond
        }
        
        return result
    }
    
    func getConditionValueType() -> ConditionValueType {
        switch self {
            case .fourDigitYear,
                .oneOrTwoDigitMonth,
                .oneOrTwoDigitDay,
                .oneOrTwoDigitHour24,
                .oneOrTwoDigitMinute,
                .oneOrTwoDigitSecond:
                return .int
            default:
                return .date
        }
    }
}
