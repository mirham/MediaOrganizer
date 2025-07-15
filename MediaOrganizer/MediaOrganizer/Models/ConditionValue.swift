//
//  ConditionValue.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import Foundation

enum ConditionValue: Codable, Equatable {
    case int(Int)
    case double(Double)
    case date(Date)
    case string(String)
    
    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    var intValue: Int? {
        if case .int(let value) = self { return value }
        return nil
    }
    
    var doubleValue: Double? {
        if case .double(let value) = self { return value }
        return nil
    }
    
    var dateValue: Date? {
        if case .date(let value) = self { return value }
        return nil
    }
    
    var stringValue: String? {
        if case .string(let value) = self { return value }
        return nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
            case Constants.ceInt:
                self = .int(try container.decode(Int.self, forKey: .value))
            case Constants.ceDouble:
                self = .double(try container.decode(Double.self, forKey: .value))
            case Constants.ceDate:
                self = .date(try container.decode(Date.self, forKey: .value))
            case Constants.ceString:
                self = .string(try container.decode(String.self, forKey: .value))
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .type,
                    in: container,
                    debugDescription: String(format: Constants.errorInvalidConditionValueType, type))
        }
    }
    
    func hasValue() -> Bool {
        return (stringValue != nil && !stringValue!.isEmpty)
                || intValue != nil
                || doubleValue != nil
                || dateValue != nil
    }
    
    func toString() -> String {
        switch self {
            case .int(let value):
                return String(value)
            case .double(let value):
                return String(value)
            case .date(let value):
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .medium
                formatter.locale = Locale.current
                return formatter.string(from: value)
            case .string(let value):
                return value
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            case .int(let value):
                try container.encode(Constants.ceString, forKey: .type)
                try container.encode(value, forKey: .value)
            case .double(let value):
                try container.encode(Constants.ceDouble, forKey: .type)
                try container.encode(value, forKey: .value)
            case .date(let value):
                try container.encode(Constants.ceDate, forKey: .type)
                try container.encode(value, forKey: .value)
            case .string(let value):
                try container.encode(Constants.ceString, forKey: .type)
                try container.encode(value, forKey: .value)
        }
    }
    
    static func == (lhs: ConditionValue, rhs: ConditionValue) -> Bool {
        switch (lhs, rhs) {
            case (.int(let a), .int(let b)):
                return a == b
            case (.double(let a), .double(let b)):
                return a == b
            case (.date(let a), .date(let b)):
                return a == b
            case (.string(let a), .string(let b)):
                return a == b
            default:
                return false
        }
    }
}
