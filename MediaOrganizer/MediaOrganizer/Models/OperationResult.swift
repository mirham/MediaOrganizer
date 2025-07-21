//
//  OperationResult.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 21.07.2025.
//

import Foundation

struct OperationResult {
    private var _logMessages: [String] = [String]()
    
    let originalUrl: URL
    var currentUrl: URL
    var actionType: ActionType?
    var logMessages: [String] { get { _logMessages } }
    var isSuccess: Bool { get { _logMessages.allSatisfy({$0.hasPrefix(Constants.info)}) } }
    
    init(originalUrl: URL) {
        self.originalUrl = originalUrl
        self.currentUrl = originalUrl
    }
    
    mutating func appendLogMessage(message: String, logLevel: LogLevel) {
        switch logLevel {
            case .info:
                _logMessages.append("\(Constants.info)\(message)")
            case .error:
                _logMessages.append("\(Constants.error)\(message)")
            default:
                break
        }
    }
}
