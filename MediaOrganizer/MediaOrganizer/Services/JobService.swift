//
//  JobService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 17.09.2024.
//

import Foundation

class JobService: ServiceBase {
    static let shared = JobService()
    
    func createJob() {
        appState.current.job = Job.makeDefault()
    }
    
    func addJob() {
        guard doesCurrentJobExist()
                && appState.current.job != Job.makeDefault()
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
}
