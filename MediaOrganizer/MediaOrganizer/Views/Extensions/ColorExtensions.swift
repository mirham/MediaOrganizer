//
//  ColorExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 18.09.2024.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var input = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        input = input.replacingOccurrences(of: Constants.sharp, with: String())
        var rgb: UInt64 = 0
        
        Scanner(string: input).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
