//
//  JobProgress.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

import Foundation

struct JobProgress {
    var notYetRun: Bool = true
    var isActive: Bool {
        get { (isAnalyzing || inProgress) && !(isCompleted || isCancelled) }
    }
    var isAnalyzing: Bool = false {
        didSet {
            notYetRun = false
        }
    }
    var inProgress: Bool = false
    var isCompleted: Bool = false
    var isCancelled: Bool = false {
        didSet {
            if progress == Constants.maxPercentage
                || (processedCount == totalCount && !isEmpty()) {
                isCancelled = false
            }
            
            if isCancelled {
                resetProgressFlags()
            }
        }
    }
    var processedCount: Int = 0 {
        didSet {
            guard processedCount != 0 || totalCount != 0 else { return }
            
            progress = (Double(processedCount) / Double(totalCount)) * Constants.maxPercentage
            
            if (progress == Constants.maxPercentage
                || processedCount == totalCount) {
                resetProgressFlags()
                isCompleted = true
            }
        }
    }
    var skippedCount: Int = 0
    var progress: Double = 0.0
    var totalCount: Int = 0
    
    func isEmpty() -> Bool {
        return self.progress == 0.0
            && self.processedCount == 0
            && self.skippedCount == 0
            && self.totalCount == 0
    }
    
    mutating func reset() {
        self.isCancelled = false
        self.isCompleted = false
        self.resetProgressFlags()
        self.resetCounters()
    }
    
    // MARK: Private functions
    
    private mutating func resetProgressFlags() {
        self.isAnalyzing = false
        self.inProgress = false
    }
    
    private mutating func resetCounters() {
        self.progress = 0.0
        self.processedCount = 0
        self.skippedCount = 0
        self.totalCount = 0
    }
}
