//
//  LogViewModel.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 16.07.2025.
//

import SwiftUI
import Combine

class LogViewModel: NSObject, ObservableObject, NSFilePresenter {
    @Published var logEntries: [LogEntry] = []
    
    var presentedItemURL: URL?
    var presentedItemOperationQueue: OperationQueue = .main
    
    private var cancellables = Set<AnyCancellable>()
    private let fileChangeSubject = PassthroughSubject<Void, Never>()
    
    init(fileURL: URL?) {
        self.presentedItemURL = fileURL
        super.init()
        loadLogContent()
        startFileMonitoring()
        
        fileChangeSubject
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadLogContent()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        stopFileMonitoring()
    }
    
    private func loadLogContent() {
        guard let fileURL = presentedItemURL else {
            DispatchQueue.main.async { [weak self] in
                self?.logEntries = []
            }
            return
        }
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.split(separator: Constants.newLine, omittingEmptySubsequences: true)
            let entries = lines.enumerated().map { index, line in
                var mutableLine = line
                let firstChar = mutableLine.removeFirst()
                return LogEntry(
                    level: self.determineLogLevel(symbol: firstChar),
                    message: String(mutableLine)
                )
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.logEntries = entries
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.logEntries = [LogEntry(
                    level: .error,
                    message: String(format: Constants.errorReadingLogFile, error.localizedDescription))]
            }
        }
    }
    
    private func startFileMonitoring() {
        guard presentedItemURL != nil else {
            return
        }
        
        NSFileCoordinator.addFilePresenter(self)
    }
    
    private func stopFileMonitoring() {
        NSFileCoordinator.removeFilePresenter(self)
    }
    
    private func determineLogLevel(symbol: Character?) -> LogLevel {
        switch symbol {
            case Constants.errorChar: return .error
            default: return .info
        }
    }
    
    func presentedItemDidChange() {
        fileChangeSubject.send()
    }
}
