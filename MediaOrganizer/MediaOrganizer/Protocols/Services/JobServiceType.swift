//
//  JobServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol JobServiceType : ServiceBaseType {
    func createJob()
    func doesCurrentJobExist() -> Bool
    func getCurrentJobId() -> UUID?
    func canRunJob(jobId: UUID) -> Bool
    func addJob()
    func duplicateJob()
    func updateJob()
    func toggleJob(jobId: UUID, checked: Bool)
    func isCurrentJob(jobId: UUID) -> Bool
    func runCheckedJobs()
    func runJob(jobId: UUID)
    func hasActiveJobs() -> Bool
    func hasCheckedInactiveJobs() -> Bool
    func abortActiveJobs()
    func resetCurrentJob()
    func removeCurrentJob()
}
