//
//  AnimatedProgressView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import SwiftUI

struct AnimatedProgressView: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(LinearProgressViewStyle())
            .padding()
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0)) {
                    progress = 1.0
                }
            }
    }
}
