//
//  UuidExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 21.07.2025.
//

import Foundation

extension UUID {
    var toStringWithoutHyphens: String {
        let emptyString = String()
        return uuidString.replacingOccurrences(of: Constants.hyphen, with: emptyString)
    }
}
