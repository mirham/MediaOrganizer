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
                makeLabel(
                    labelText: Constants.elNotYetRun,
                    fillColor: Color.gray)
                    .isHidden(hidden: !job.progress.notYetRun, remove: true)
                makeLabel(
                    labelText: Constants.elCompleted,
                    fillColor: job.progress.errorsCount == 0 ? Color.green : Color.orange)
                    .isHidden(hidden: !job.progress.isCompleted, remove: true)
                makeLabel(
                    labelText: Constants.elCanceled,
                    fillColor: Color.red)
                    .isHidden(hidden: !job.progress.isCancelled, remove: true)
                makeLogLabel()
                    .isHidden(
                        hidden:!(job.progress.isCompleted || job.progress.isCancelled),
                        remove: true)
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
            .gesture(TapGesture(count: 1).onEnded {
                appState.current.logJobId = job.id
                
                if !appState.views.isWindowShown(windowId: Constants.windowIdLog) {
                    openWindow(id: Constants.windowIdLog)
                }
                
                ViewHelper.activateView(viewId: Constants.windowIdLog)
            })
    }
    
    @ViewBuilder
    private func makeLogLabel() -> some View {
        let hasErrors = job.progress.errorsCount > 0
        
        HStack(alignment: .center) {
            Circle()
                .fill(hasErrors ? .red : .green)
                .frame(width: 10, height: 10)
                .padding(hasErrors ? 0 : 3)
            Text(job.progress.errorsCount.formatted())
                .isHidden(hidden: !hasErrors, remove: true)
        }
        .padding(.leading, 5)
        .padding(.trailing, 5)
        .contentShape(Rectangle())
        .frame(alignment: .center)
        .offset(y: 15)
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .offset(y: 15)
                .fill(.gray)
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
