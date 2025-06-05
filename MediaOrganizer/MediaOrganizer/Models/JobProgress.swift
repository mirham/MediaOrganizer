//
//  JobProgress.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 05.06.2025.
//

struct JobProgress {
    var notYetRun: Bool = true
    var isAnalyzing: Bool = false {
        didSet {
            notYetRun = false
        }
    }
    var inProgress: Bool = false
    var isCompleted: Bool = false
    var isCancelRequested: Bool = false {
        didSet {
            if progress == Constants.maxPercentage || processedCount == totalCount {
                isCancelRequested = false
            }
        }
    }
    var processedCount: Int = 0 {
        didSet {
            guard processedCount != 0 || totalCount != 0 else { return }
            
            progress = (Double(processedCount) / Double(totalCount)) * Constants.maxPercentage
            
            if (progress == Constants.maxPercentage
                || processedCount == totalCount) {
                inProgress = false
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
        self.isCancelRequested = false
        self.progress = 0.0
        self.processedCount = 0
        self.skippedCount = 0
        self.totalCount = 0
        self.isAnalyzing = false
        self.isCompleted = false
    }
}
