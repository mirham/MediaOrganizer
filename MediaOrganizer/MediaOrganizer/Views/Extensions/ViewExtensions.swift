//
//  ViewExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import SwiftUI

extension View {
    func isHidden(hidden: Bool = false, remove: Bool = false) -> some View {
        modifier(IsHiddenModifier(hidden: hidden, remove: remove))
    }
}
