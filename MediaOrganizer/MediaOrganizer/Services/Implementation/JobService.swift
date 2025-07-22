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
    
    func canRunJob(jobId: UUID) -> Bool {
        let job = appState.userData.jobs
            .first(where: { $0.id == jobId })
        
        guard let job = job else { return false }
        
        var isFolder: ObjCBool = true
        let doesSourceFolderExist = FileManager.default.fileExists(
            atPath: job.sourceFolder,
            isDirectory: &isFolder)
        let doesOutputFolderExist = FileManager.default.fileExists(
            atPath: job.outputFolder,
            isDirectory: &isFolder)
        
        return doesSourceFolderExist && doesOutputFolderExist
    }
    
    func addJob() {
        guard doesCurrentJobExist()
                && appState.current.job != Job.initDefault()
                && getJobIndexByJobId(jobId: appState.current.job!.id) == nil
        else { return }
        
        guard let currentJob = appState.current.job
        else { return }
        
        appState.userData.jobs.append(currentJob)
    }
    
    func duplicateJob() {
        guard let currentJob = appState.current.job
        else { return }
        
        let clonedJob = currentJob.clone()
        clonedJob.name = makeDuplicatedJobName(currentJobName: clonedJob.name)
        
        appState.userData.jobs.append(clonedJob)
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
        guard let currentJob = appState.current.job
        else { return false }
        
        return currentJob.id == jobId
    }
    
    func runCheckedJobs() {
        let checkedInactiveJobs = appState.userData.jobs
            .filter({ $0.checked && !$0.progress.isActive && canRunJob(jobId: $0.id) })
        
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
    
    private func makeDuplicatedJobName(currentJobName: String) -> String {
        let currentJobNames = appState.userData.jobs.map { $0.name }
        var counter = 1
        var result = currentJobName.range(
            of: Constants.regexSearchCopySuffix,
            options: [.regularExpression, .caseInsensitive]) != nil
            ? currentJobName
            : "\(currentJobName) \(Constants.elCopy.uppercased())"
        
        while currentJobNames.contains(where: {$0.uppercased() == result.uppercased()}) {
            if let range = result.range(
                of: Constants.regexSearchCopySuffixToReplace,
                options: [.regularExpression, .caseInsensitive]) {
                result = result.replacingCharacters(in: range, with: Constants.elCopy.uppercased())
            }
            
            result = "\(result) \(counter)"
            counter += 1
        }
        
        return result
    }
    
    private func runJobAsync(job: Job) async {
        await MainActor.run {
            job.progress.reset()
            job.progress.isAnalyzing = true
            job.progress.refreshSignal.toggle()
        }
        
        let jobLog = JobLog(jobId: job.id)
        jobLog.clearLogFile()
        
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
                    
                    let operationResult = await processFile(fileInfo, for: job)
                    
                    await MainActor.run {
                        if operationResult.isSuccess {
                            if operationResult.isEmpty {
                                job.progress.skippedCount += Constants.step
                            }
                            else {
                                job.progress.processedCount += Constants.step
                            }
                        }
                        else {
                            job.progress.processedCount += Constants.step
                            job.progress.errorsCount += Constants.step
                        }
                        
                        jobLog.write(operationResult.logMessages)
                    }
                }
            }
            
            await MainActor.run {
                job.progress.inProgress = false
                job.progress.isCompleted = true
                job.progress.refreshSignal.toggle()
            }
        }
        catch is CancellationError {
            jobLog.info(Constants.lmJobCancelled)
            
            await MainActor.run {
                job.progress.inProgress = false
                job.progress.isCancelled = true
                job.progress.refreshSignal.toggle()
            }
        }
        catch {
            jobLog.error(String(format:Constants.lmJobFailed, error.localizedDescription))
            await MainActor.run {
                job.progress.errorsCount += 1
                job.progress.refreshSignal.toggle()
            }
        }
    }
    
    private func processFile(_ fileInfo: MediaFileInfo, for job: Job) async -> OperationResult {
        var result = OperationResult(originalUrl: fileInfo.originalUrl)
        
        for rule in job.rules {
            let fileActions = applyRule(
                rule: rule,
                fileInfo: fileInfo,
                operationResult: &result)
            
            guard result.isSuccess else { continue }
            
            await fileService.peformFileActionsAsync(
                outputPath: job.outputFolder,
                fileInfo: fileInfo,
                fileActions: fileActions,
                duplicatesPolicy: job.duplicatesPolicy,
                operationResult: &result
            )
        }
        
        return result
    }
    
    private func applyRule(
        rule: Rule,
        fileInfo: MediaFileInfo,
        operationResult: inout OperationResult) -> [FileAction] {
        do {
            let result = try ruleService.applyRule(rule: rule, fileInfo: fileInfo)
            
            return result
        }
        catch {
            operationResult.appendLogMessage(
                message: String(format: Constants.errorCannotApplyRule, error.localizedDescription),
                logLevel: .error)
        }
        
        return [FileAction]()
    }
}
