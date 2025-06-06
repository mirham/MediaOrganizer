//
//  JobAbortView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import SwiftUI
import Factory

struct JobRunView: View {
    @ObservedObject var job: Job
    
    @Injected(\.jobService) private var jobService
    
    @State private var overRunButton = false
    
    var body: some View {
        Button(action: runJob, label: {
            Image(systemName: Constants.iconRun)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding(7)
        })
        .buttonStyle(.plain)
        .focusEffectDisabled()
        .foregroundStyle(overRunButton ? .green : .blue)
        .isHidden(hidden: job.progress.isActive, remove: true)
        .popover(isPresented: $overRunButton, content: {
            renderHint()
        })
        .onHover(perform: {over in
            overRunButton = over
        })
    }
    
    // MARK: Private functions
    
    private func runJob() {
        jobService.runJob(jobId: job.id)
    }
    
    private func renderHint() -> some View {
        let result = Text(String(format: Constants.hintRunJob, job.name))
            .padding()
            .interactiveDismissDisabled()
        
        return result
    }
}
