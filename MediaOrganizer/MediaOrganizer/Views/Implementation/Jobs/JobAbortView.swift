//
//  JobAbortView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import SwiftUI

struct JobAbortView: View {
    @ObservedObject var job: Job
    
    @State private var overAbortButton = false
    
    var body: some View {
        Button(action: cancelJob, label: {
            Image(systemName: Constants.iconStop)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(7)
                .padding(.trailing, 15)
        })
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .foregroundStyle(overAbortButton ? .red : .blue)
        //.isHidden(hidden: !job.progress.inProgress, remove: true)
        .popover(isPresented: $overAbortButton, content: {
            renderHint()
        })
        .onHover(perform: {over in
            overAbortButton = over
        })
    }
    
    // MARK: Private functions
    
    private func cancelJob() {
        job.progress.isCancelRequested = true
    }
    
    private func renderHint() -> some View {
        let result = Text(String(format: Constants.hintAbortJob, job.name))
            .padding()
            .interactiveDismissDisabled()
        
        return result
    }
}
