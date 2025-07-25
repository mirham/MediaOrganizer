//
//  ColorThemeSupportedView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 25.07.2025.
//

import SwiftUI

protocol ColorThemeSupportedView : View {}

extension ColorThemeSupportedView {
    func getPanelColor(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
            case .dark:
                return Color(hex: Constants.colorHexPanelDark)
            case .light:
                return Color(hex: Constants.colorHexPanelLight)
            @unknown default:
                return .gray
        }
    }
    
    func getOperatorColor(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
            case .dark:
                return .gray
            case .light:
                return .black.opacity(0.5)
            @unknown default:
                return .gray
        }
    }
}
