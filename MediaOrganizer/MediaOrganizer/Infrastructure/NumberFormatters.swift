//
//  NumberFormatters.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 09.05.2025.
//

import Foundation

struct NumberFormatters {
    static var fourFractionDigits: Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        formatter.decimalSeparator = Constants.dot
        return formatter
    }
}
