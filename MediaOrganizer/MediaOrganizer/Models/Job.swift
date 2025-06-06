//
//  Job.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import Foundation

class Job : Codable, Identifiable, Equatable, ObservableObject {
    var id = UUID()
    var checked: Bool
    var name: String
    var sourceFolder: String
    var outputFolder: String
    var rules: [Rule] = [Rule]()
    
    @Published var progress: JobProgress = JobProgress()
    
    private enum CodingKeys: String, CodingKey {
        case id
        case checked
        case name
        case sourceFolder
        case outputFolder
        case rules
    }
    
    init(name: String,
        sourceFolder: String,
        outputFolder: String) {
        self.checked = true
        self.name = name
        self.sourceFolder = sourceFolder
        self.outputFolder = outputFolder
    }
    
    static func initDefault() -> Job {
        let result = Job(
            name: Constants.defaultJobName,
            sourceFolder: Constants.stubNotSelected,
            outputFolder: Constants.stubNotSelected)
        
        return result
    }
    
    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.name == rhs.name
        && lhs.sourceFolder == rhs.sourceFolder
        && lhs.outputFolder == rhs.outputFolder
    }
}
