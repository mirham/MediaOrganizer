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
    // TODO: Fix this crap below!
    var isSuccess: Bool {
        get { _logMessages.allSatisfy({!$0.hasPrefix(Constants.error)}) }
    }
    var isEmpty: Bool { get { originalUrl == currentUrl } }
    
    init(originalUrl: URL) {
        self.originalUrl = originalUrl
        self.currentUrl = originalUrl
    }
    
    mutating func appendLogMessage(message: String, logLevel: LogLevel) {
        let timestamp = self.dateFormatter.string(from: Date())
        
        switch logLevel {
            case .info:
                _logMessages.append("\(Constants.info) \(timestamp) \(message)")
            case .warning:
                _logMessages.append("\(Constants.warning) \(timestamp) \(message)")
            case .error:
                _logMessages.append("\(Constants.error) \(timestamp) \(message)")
            default:
                break
        }
    }
}
