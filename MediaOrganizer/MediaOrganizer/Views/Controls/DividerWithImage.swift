//
//  DividerWithImage.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 19.09.2024.
//

import SwiftUI

struct DividerWithImage: View {
    let imageName: String
    let padding: CGFloat
    let color: Color
    
        init(imageName: String, padding: CGFloat = 5, color: Color = .gray) {
        self.imageName = imageName
        self.padding = padding
        self.color = color
    }
    
    var body: some View {
        let layout = AnyLayout(VStackLayout())
        
        layout {
            dividerLine
            Image(systemName: imageName)
                .foregroundStyle(color)
                .offset(y: -(padding * 3))
        }
    }
    
    private var dividerLine: some View {
        let layout = AnyLayout(VStackLayout())
        
        return layout { Divider().foregroundStyle(color) }.padding(padding)
    }
}
