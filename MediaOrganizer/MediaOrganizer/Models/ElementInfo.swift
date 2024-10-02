//
//  ElementInfo.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 01.10.2024.
//

import Foundation

struct ElementInfo : Codable, Equatable {
    let elementTypeId: Int
    let displayText: String
    let settingType: ElementValueType?
    var selectedFormat: String?
    var value: String?
}
