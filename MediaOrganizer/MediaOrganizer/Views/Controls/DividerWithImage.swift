//
//  DividerWithImage.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 19.09.2024.
//

import SwiftUI

struct DividerWithImage: View {
    let imageName: String
    let imageSize: CGFloat
    let lineColor: Color
    let lineHeight: CGFloat
    
    init(imageName: String = Constants.iconDown,
         imageSize: CGFloat = 16,
         lineColor: Color = .gray,
         lineHeight: CGFloat = 1) {
        self.imageName = imageName
        self.imageSize = imageSize
        self.lineColor = lineColor
        self.lineHeight = lineHeight
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(lineColor.opacity(0.4))
                .frame(height: lineHeight)
            Image(systemName: Constants.iconDown)
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
                .foregroundColor(lineColor)
                .frame(height: 0)
        }
        .frame(height: lineHeight)
    }
}
