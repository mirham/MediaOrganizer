//
//  JobLogType.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 15.07.2025.
//

import Foundation

protocol JobLogType {
    init(jobId: UUID)
    func debug(_ message: String)
    func info(_ message: String)
    func error(_ message: String)
    func getLogFileUrl() -> URL?
    func clearLogFile()
    func deleteLogFile()
}
