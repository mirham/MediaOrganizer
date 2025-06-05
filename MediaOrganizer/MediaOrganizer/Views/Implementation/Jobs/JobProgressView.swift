//
//  JobProgressView.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import SwiftUI

struct JobProgressView: View {
    @ObservedObject var job: Job
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Constants.elNotYetRun)
                    .textCase(.uppercase)
                    .offset(y: 15)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.gray)
                            .offset(y: 15)
                    )
                    .isHidden(hidden: !job.progress.notYetRun, remove: true)
                Text(Constants.elAnalyzingFiles)
                    .offset(y: 10)
                    .isHidden(hidden: !job.progress.isAnalyzing, remove: true)
                Text(Constants.elCompleted)
                    .textCase(.uppercase)
                    .offset(y: 15)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.green)
                            .offset(y: 15)
                    )
                    .isHidden(hidden: !job.progress.isCompleted, remove: true)
                Text(Constants.elCanceled)
                    .textCase(.uppercase)
                    .offset(y: 15)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.red)
                            .offset(y: 15)
                    )
                    .isHidden(hidden: !job.progress.isCancelRequested, remove: true)
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
}
