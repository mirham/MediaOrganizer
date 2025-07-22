//
//  OperationResult.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 21.07.2025.
//

import Foundation

struct OperationResult {
    private var _logMessages: [String] = [String]()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.defaultLogEntryDateFormat
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    let originalUrl: URL
    var currentUrl: URL
    var actionType: ActionType?
    var logMessages: [String] { get { _logMessages } }
    var isSuccess: Bool { get { _logMessages.allSatisfy({$0.hasPrefix(Constants.info)}) } }
    var isEmpty: Bool { get { _logMessages.isEmpty } }
    
    init(originalUrl: URL) {
        self.originalUrl = originalUrl
        self.currentUrl = originalUrl
    }
    
    mutating func appendLogMessage(message: String, logLevel: LogLevel) {
        let timestamp = self.dateFormatter.string(from: Date())
        
        switch logLevel {
            case .info:
                _logMessages.append("\(Constants.info) \(timestamp) \(message)")
            case .error:
                _logMessages.append("\(Constants.error) \(timestamp) \(message)")
            default:
                break
        }
    }
}
