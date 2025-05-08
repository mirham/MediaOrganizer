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
    
    func runCheckedJobsAsync() async {
        let checkedJobs = appState.userData.jobs.filter({ $0.checked })
        
        guard !checkedJobs.isEmpty else { return }
        
        for job in checkedJobs {
            await runJobAsync(job: job)
        }
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
        Task.detached(priority: .high) {
            let mediaFiles = await self.fileService.getFolderMediaFilesAsync(path: job.sourceFolder)
            
            // TODO: Apply conditions (filter files)
            
            for fileInfo in mediaFiles {
                for rule in job.rules {
                    let fileActions = self.ruleService.applyRule(rule:rule, fileInfo: fileInfo)
                    await self.fileService.peformFileActionsAsync(
                        outputPath: job.outputFolder,
                        fileInfo: fileInfo,
                        fileActions: fileActions)
                }
            }
        }
    }
}
