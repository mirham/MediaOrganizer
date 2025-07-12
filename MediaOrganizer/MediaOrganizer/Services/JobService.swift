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
    
    func doesCurrentJobExist() -> Bool {
        guard appState.current.job != nil else { return false }
        
        return true
    }
    
    func getCurrentJobId() -> UUID? {
        guard let currentJob = appState.current.job else { return nil }
        
        return currentJob.id
    }
    
    func addJob() {
        guard doesCurrentJobExist()
                && appState.current.job != Job.initDefault()
                && getJobIndexByJobId(jobId: appState.current.job!.id) == nil
        else { return }
        
        appState.userData.jobs.append(appState.current.job!)
    }
    
    func updateJob() {
        guard let currentJobId = getCurrentJobId(),
              let currentJob = appState.current.job
        else { return }
        
        if let jobIndex = getJobIndexByJobId(jobId: currentJobId) {
            appState.userData.jobs[jobIndex] = currentJob
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
        guard let currentJob = appState.current.job else { return false }
        
        return currentJob.id == jobId
    }
    
    func runCheckedJobs() {
        let checkedInactiveJobs = appState.userData.jobs
            .filter({ $0.checked && !$0.progress.isActive })
        
        guard !checkedInactiveJobs.isEmpty else { return }
        
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
    }
    
    func runJob(jobId: UUID) {
        let job = appState.userData.jobs
            .first(where: { $0.id == jobId && !$0.progress.isActive })
        
        guard let job = job else { return }
        
        Task.detached(priority: .userInitiated) {
            await self.runJobAsync(job: job)
        }
    }
    
    func hasActiveJobs() -> Bool {
        let result = appState.userData.jobs
            .contains(where: {$0.progress.isActive})
        
        return result
    }
    
    func hasCheckedInactiveJobs() -> Bool {
        let result = appState.userData.jobs
            .contains(where: {$0.checked && !$0.progress.isActive})
        
        return result
    }
    
    func abortActiveJobs() {
        let activeJobs = appState.userData.jobs.filter({ $0.progress.isActive })
        
        guard !activeJobs.isEmpty else { return }
        
        for activeJob in activeJobs {
            activeJob.progress.isCancelled = true
        }
        
        jobsTask?.cancel()
    }
    
    func resetCurrentJob() {
        appState.current.job = nil
    }
    
    func removeCurrentJob() {
        guard let currentJobId = getCurrentJobId() else { return }
        
        if let jobIndex = getJobIndexByJobId(jobId: currentJobId) {
            appState.userData.jobs.remove(at: jobIndex)
            resetCurrentJob()
        }
    }
    
    // MARK: Private functions
    
    private func getJobIndexByJobId(jobId: UUID) -> Int? {
        let result = appState.userData.jobs.firstIndex(where: {$0.id == jobId})
        
        return result
    }
    
    private func runJobAsync(job: Job) async {
        await MainActor.run {
            job.progress.reset()
            job.progress.isAnalyzing = true
            job.progress.refreshSignal.toggle()
        }
        
        do {
            let mediaFiles = try await fileService.getFolderMediaFilesAsync(
            path: job.sourceFolder,
            jobProgress: job.progress)
        
            if !job.progress.isCancelled {
                await MainActor.run {
                    job.progress.isAnalyzing = false
                    job.progress.totalCount = mediaFiles.count
                    job.progress.inProgress = true
                    job.progress.refreshSignal.toggle()
                }
            }
            
            let batchSize = Constants.threadChunk

            for batch in mediaFiles.chunked(into: batchSize) {
                try await batch.asyncForEach { fileInfo in
                    try Task.checkCancellation()
                    
                    if job.progress.isCancelled {
                        throw CancellationError()
                    }
                    
                    let wasProcessed = await processFile(fileInfo, for: job)
                    
                    await MainActor.run {
                        if wasProcessed {
                            job.progress.processedCount += Constants.step
                        }
                        else {
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
            job.progress.refreshSignal.toggle()
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
