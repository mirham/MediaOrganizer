//
//  StringExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 07.05.2025.
//

import Foundation

extension StringProtocol {
    var firstLowercased: String { return prefix(1).lowercased() + dropFirst() }
    var withColonsInsteadSlashes: String {
        return replacingOccurrences(of: Constants.slash, with:Constants.colon) }
}

extension String: @retroactive Error {}

extension String: @retroactive LocalizedError {
    public var errorDescription: String? { return self }
}
