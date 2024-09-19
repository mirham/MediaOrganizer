//
//  IsHiddenModifier.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI

struct IsHiddenModifier: ViewModifier {
    var hidden = false
    var remove = false
    
    func body(content: Content) -> some View {
        if hidden {
            if !remove {
                content.hidden()
            }
        } else {
            content
        }
    }
}
