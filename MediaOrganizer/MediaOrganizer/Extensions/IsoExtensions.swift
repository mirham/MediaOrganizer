//
//  IsoExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.10.2024.
//

import Foundation
import CoreLocation

public struct IsoString {
    public static func parseFromIso6709String(iso6709String text: String?) -> CLLocation? {
        guard
            let results = text?.capture(pattern: Constants.regexLocationInIso6709),
            let latitude = results[safe: 1] as NSString?,
            let longitude = results[safe: 2] as NSString?
        else { return nil }
        
        return CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    }
    
    public static func parseToIso6709String(from location: CLLocation) -> String {
        String(
            format: Constants.regexEncodedLocationInIso6709,
            location.coordinate.latitude,
            location.coordinate.longitude,
            location.altitude
        )
    }
    
    public static func parseFromIso8601String(iso8601String text: String?) -> Date? {
        guard
            let text = text,
            let date = ISO8601DateFormatter().date(from: text)
        else { return nil }
        
        return Date(timeInterval: 0, since: date)
    }
    
    public static func parseToIso8601String(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions.remove(.withColonSeparatorInTimeZone)
        
        return formatter.string(from: date)
    }
}
private extension String {
    func capture(pattern: String) -> [String] {
        guard
            let regex = try? NSRegularExpression(pattern: pattern),
            let result = regex.firstMatch(in: self, range: NSRange(location: 0, length: count))
        else {
            return []
        }
        
        return (0..<result.numberOfRanges).map {
            String(self[Range(result.range(at: $0), in: self)!])
        }
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension CLLocation {
    convenience init?(iso6709 text: String?) {
        guard let location = IsoString.parseFromIso6709String(iso6709String: text)
        else {
            return nil
        }
        
        self.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    var iso6709: String {
        IsoString.parseToIso6709String(from: self)
    }
}

public extension Date {
    init?(iso8601 text: String?) {
        guard let date = IsoString.parseFromIso8601String(iso8601String: text) else { return nil }
        self = date
    }
    
    var iso8601: String {
        IsoString.parseToIso8601String(from: self)
    }
}
