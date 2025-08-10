//
//  ImageExtensions.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 10.08.2025.
//

import SwiftUI

extension Image {
    func nonAntialiased () -> Image {
        self.interpolation(.none)
            .antialiased(false)
    }
    
    func asSmallInfoIcon() -> some View {
        self.resizable()
            .frame(width: 14, height: 14)
            .foregroundColor(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/)
            .padding(.leading, 6)
    }
    
    func asInfoIcon() -> some View {
        self.resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/)
            .padding(.leading)
            .padding(.trailing, 5)
    }
}
