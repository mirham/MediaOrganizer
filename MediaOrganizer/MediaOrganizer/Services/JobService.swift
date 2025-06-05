//
//  JobService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation
import Factory

class JobService: ServiceBase, JobServiceType {
    @Injected(\.fileService) private var fileService
    @Injected(\.ruleService) private var ruleService
    
    var jobsTask: Task<Void, Never>?
    
    func createJob() {
        appState.current.job = Job.initDefault()
    }
    
    func addJob() {
        guard doesCurrentJobExist()
                && appState.current.job != Job.initDefault()
                && getJobIndexByJobId(jobId: appState.current.job!.id) == nil
        else { return }
        
        appState.userData.jobs.append(appState.current.job!)
    }
    
    func updateJob() {
        guard doesCurrentJobExist() else { return }
        
        if let jobIndex = getJobIndexByJobId(jobId: getCurrentJobId()!) {
            appState.userData.jobs[jobIndex] = appState.current.job!
        }
    }
    
    func toggleJob(jobId: UUID, checked: Bool) {
        if let jobIndex = getJobIndexByJobId(jobId: jobId) {
            let job = appState.userData.jobs[jobIndex]
            job.checked = checked
            appState.userData.jobs[jobIndex] = job
        }
    }
    
    func isCurrentJob(jobId: UUID) -> Bool {
        guard appState.current.job != nil else { return false }
        
        let result = appState.current.job!.id == jobId
        
        return result
    }
    
    func runCheckedJobs() {
        let checkedInactiveJobs = appState.userData.jobs
            .filter({ $0.checked && !$0.progress.inProgress })
        
        guard !checkedInactiveJobs.isEmpty else { return }
        
        appState.current.hasActiveJobs = true
        
        jobsTask = Task.detached(priority: .userInitiated) {
            await withTaskGroup(of: Void.self) { group in
                for job in checkedInactiveJobs {
                    group.addTask {
                        await self.runJobAsync(job: job)
                    }
                }
                
                await group.waitForAll()
            }
        }
        
        appState.current.hasActiveJobs = false
    }
    
    func abortActiveJobs() {
        let activeJobs = appState.userData.jobs.filter({ $0.progress.inProgress })
        
        guard !activeJobs.isEmpty else { return }
        
        for activeJob in activeJobs {
            activeJob.progress.isCancelRequested = true
        }
        
        jobsTask?.cancel()
    }
    
    func resetCurrentJob() {
        appState.current.job = nil
    }
    
    func removeCurrentJob() {
        guard appState.current.job != nil else { return }
        
        if let jobIndex = getJobIndexByJobId(jobId: getCurrentJobId()!) {
            appState.userData.jobs.remove(at: jobIndex)
            resetCurrentJob()
        }
    }
    
    // MARK: Private functions
    
    private func runJobAsync(job: Job) async {
        await MainActor.run {
            job.progress.reset()
            job.progress.isAnalyzing = true
        }
        
        let mediaFiles = await fileService.getFolderMediaFilesAsync(path: job.sourceFolder)
        let batchSize = Constants.threadChunk
        
        await MainActor.run {
            job.progress.isAnalyzing = false
            job.progress.totalCount = mediaFiles.count
            job.progress.inProgress = true
        }
        
        do {
            for batch in mediaFiles.chunked(into: batchSize) {
                try await batch.asyncForEach { fileInfo in
                    try Task.checkCancellation()
                    
                    if job.progress.isCancelRequested {
                        throw CancellationError()
                    }
                    
                    let wasProcessed = await processFile(fileInfo, for: job)
                    
                    await MainActor.run {
                        job.progress.processedCount += Constants.step
                        
                        if !wasProcessed {
                            job.progress.skippedCount += Constants.step
                        }
                    }
                }
            }
        } catch is CancellationError {
            print("Job \(job.id) cancelled")
        }
        catch {
            print("Job \(job.id) failed: \(error)")
        }
        
        await MainActor.run {
            job.progress.inProgress = false
        }
    }
    
    private func processFile(_ fileInfo: MediaFileInfo, for job: Job) async -> Bool {
        for rule in job.rules {
            let fileActions = ruleService.applyRule(rule: rule, fileInfo: fileInfo)
            
            guard !fileActions.isEmpty else { continue }
            
            await fileService.peformFileActionsAsync(
                outputPath: job.outputFolder,
                fileInfo: fileInfo,
                fileActions: fileActions
            )
            return true
        }
        return false
    }
}
