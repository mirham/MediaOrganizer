//
//  ElementOptions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import SwiftUI

struct ElementOptions {
    let icon: Image?
    var background: Color
    let hasFormula: Bool
    let editableInAction: Bool
    let editableInCondition: Bool
    let elementValueType: ElementValueType
    var conditionValueType: ConditionValueType? = nil
    
    mutating func adjustBackgroundOpacity(opacity: Double) {
        self.background = background.opacity(opacity)
    }
}
