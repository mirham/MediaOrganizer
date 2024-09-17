//
//  Job.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.09.2024.
//

import Foundation

class Job : Codable, Identifiable, Equatable {
    var id = UUID()
    var checked: Bool
    var name: String
    var sourceFolder: String
    var outputFolder: String
    
    init(name: String,
        sourceFolder: String,
        outputFolder: String) {
        self.checked = true
        self.name = name
        self.sourceFolder = sourceFolder
        self.outputFolder = outputFolder
    }
    
    func check(isChecked: Bool) {
        self.checked = isChecked
    }
    
    static func makeDefault() -> Job {
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
