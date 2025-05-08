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
    case fourDigitYear = 6
    case twoDigitYear = 7
    case twoDigitMonth = 8
    case oneOrTwoDigitMonth = 9
    case twoDigitDay = 10
    case oneOrTwoDigitDay = 11
    case twoDigitHour24 = 12
    case oneOrTwoDigitHour24 = 13
    case twoDigitHour12 = 14
    case oneOrTwoDigitHour12 = 15
    case twoDigitMinute = 16
    case oneOrTwoDigitMinute = 17
    case twoDigitSecond = 18
    case oneOrTwoDigitSecond = 19
    case amPm = 20
    
    var description: String {
        switch self {
            case .asIs: return "As is"
            case .dateEu: return "Date in EU format"
            case .dateUs: return "Date in US format"
            case .dateTimeEu: return "Date and time in EU format"
            case .dateTimeUs: return "Date and time in US format"
            case .monthAndDay: return "Month and day"
            case .fourDigitYear: return "4-digit year"
            case .twoDigitYear: return "2-digit year"
            case .twoDigitMonth: return "2-digit month"
            case .oneOrTwoDigitMonth: return "1 or 2 digit month"
            case .twoDigitDay: return "2-digit day"
            case .oneOrTwoDigitDay: return "1 or 2 digit day"
            case .twoDigitHour24: return "2-digit hour (24-hour format)"
            case .oneOrTwoDigitHour24: return "1 or 2 digit hour (24-hour format)"
            case .twoDigitHour12: return "2-digit hour (12-hour format)"
            case .oneOrTwoDigitHour12: return "1 or 2 digit hour (12-hour format)"
            case .twoDigitMinute: return "2-digit minute"
            case .oneOrTwoDigitMinute: return "1 or 2 digit minute"
            case .twoDigitSecond: return "2-digit second"
            case .oneOrTwoDigitSecond: return "1 or 2 digit second"
            case .amPm: return "AM/PM for 12-hour format"
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
            case .dateEu: return "05.01.2024"
            case .dateUs: return "01/05/2024"
            case .dateTimeEu: return "05.01.2024 16-10-42"
            case .dateTimeUs: return "01/05/2024 16-10-42"
            case .monthAndDay: return "12.31"
            case .fourDigitYear: return "2024"
            case .twoDigitYear: return "24"
            case .twoDigitMonth: return "01"
            case .oneOrTwoDigitMonth: return "1"
            case .twoDigitDay: return "05"
            case .oneOrTwoDigitDay: return "5"
            case .twoDigitHour24: return "06"
            case .oneOrTwoDigitHour24: return "6"
            case .twoDigitHour12: return "01"
            case .oneOrTwoDigitHour12: return "1"
            case .twoDigitMinute: return "02"
            case .oneOrTwoDigitMinute: return "2"
            case .twoDigitSecond: return "03"
            case .oneOrTwoDigitSecond: return "3"
            case .amPm: return "PM"
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
}
