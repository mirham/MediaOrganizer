//
//  JobServiceType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 06.05.2025.
//


import Foundation

protocol JobServiceType : ServiceBaseType {
    func createJob()
    func addJob()
    func updateJob()
    func toggleJob(jobId: UUID, checked: Bool)
    func isCurrentJob(jobId: UUID) -> Bool
    func runCheckedJobsAsync() async
    func resetCurrentJob()
    func removeCurrentJob()
}
