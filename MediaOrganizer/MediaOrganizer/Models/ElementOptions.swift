//
//  ElementOptions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 02.10.2024.
//

import SwiftUI

struct ElementOptions {
    let icon: Image?
    let background: Color
    let hasFormula: Bool
    let editable: Bool
    let elementValueType: ElementValueType
    var conditionValueType: ConditionValueType? = nil
}
