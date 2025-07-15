//
//  JobProgressView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import SwiftUI

struct JobProgressView: View {
    @EnvironmentObject var appState: AppState
    
    @Environment(\.openWindow) private var openWindow
    
    @ObservedObject var job: Job
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                makeLabel(labelText: Constants.elNotYetRun, fillColor: Color.gray)
                    .isHidden(hidden: !job.progress.notYetRun, remove: true)
                makeLabel(labelText: Constants.elCompleted, fillColor: Color.green)
                    .isHidden(hidden: !job.progress.isCompleted, remove: true)
                makeLabel(labelText: Constants.elCanceled, fillColor: Color.red)
                    .isHidden(hidden: !job.progress.isCancelled, remove: true)
                makeLogButton()
                Text(Constants.elAnalyzingFiles)
                    .offset(y: 10)
                    .isHidden(hidden: !job.progress.isAnalyzing, remove: true)
                Text("\(job.progress.processedCount) processed and \(job.progress.skippedCount) skipped of \(job.progress.totalCount) file(s) (\(job.progress.progress, specifier: "%.1f")%)" )
                    .offset(y: job.progress.inProgress ? 10 : 15)
                    .isHidden(hidden: job.progress.isEmpty(), remove: false)
            }
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle())
                .isHidden(hidden: !job.progress.isAnalyzing, remove: true)
            ProgressView(
                value: job.progress.progress,
                total: Constants.maxPercentage)
            .isHidden(hidden: !job.progress.inProgress, remove: job.progress.isAnalyzing)
        }
    }
    
    // MARK: Private functions
    
    @ViewBuilder
    private func makeLabel(labelText: String, fillColor: Color) -> some View {
        Text(labelText)
            .textCase(.uppercase)
            .offset(y: 15)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(fillColor)
                    .offset(y: 15)
            )
    }
    
    @ViewBuilder
    private func makeLogButton() -> some View {
        let hasErrors = job.progress.errorsCount > 0
        
        Text(hasErrors ? "\(Constants.error) \(job.progress.errorsCount)" : "\(Constants.info)")
            .textCase(.uppercase)
            .offset(y: 15)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.gray)
                    .offset(y: 15)
            )
            .gesture(TapGesture(count: 1).onEnded {
                appState.current.logJobId = job.id
                
                if !appState.views.isWindowShown(windowId: Constants.windowIdLog) {
                    openWindow(id: Constants.windowIdLog)
                }
                
                ViewHelper.activateView(viewId: Constants.windowIdLog)
            })
    }
}
