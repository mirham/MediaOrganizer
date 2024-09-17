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
        guard appState.current.job != nil && appState.current.job != Job.makeDefault() else { return }
        
        appState.userData.jobs.append(appState.current.job!)
    }
    
    func updateJob() {
        guard appState.current.job != nil else { return }
        
        if let jobId = appState.userData.jobs.firstIndex(where: {$0.id == appState.current.job!.id}) {
            appState.userData.jobs[jobId] = appState.current.job!
        }
    }
    
    func toggleJob(jobId: UUID, checked: Bool) {
        if let jobIndex = appState.userData.jobs.firstIndex(where: {$0.id == jobId}) {
            let job = appState.userData.jobs[jobIndex]
            job.checked = checked
            appState.userData.jobs[jobIndex] = job
        }
    }
    
    func doesCurrentJobExist() -> Bool {
        appState.current.job != nil
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
        
        if let jobIndex = appState.userData.jobs.firstIndex(where: {$0.id == appState.current.job!.id}) {
            appState.userData.jobs.remove(at: jobIndex)
            resetCurrentJob()
        }
    }
}
