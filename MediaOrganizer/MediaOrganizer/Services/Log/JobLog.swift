//
//  LoggingService.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 15.07.2025.
//

import Foundation

class JobLog: ServiceBase, JobLogType {
    private let jobId: UUID
    private let subsystem = Bundle.main.bundleIdentifier ?? Constants.defaultAppBundleName
    private let fileQueue = DispatchQueue(label: Constants.loggerQueueLabel, qos: .background)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.defaultLogEntryDateFormat
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    required init(jobId: UUID) {
        self.jobId = jobId
    }
    
    func debug(_ message: String) {
        log(message, .debug)
    }
    
    func info(_ message: String) {
        log(message, .info)
    }
    
    func error(_ message: String) {
        log(message, .error)
    }
    
    func getLogFileUrl() -> URL? {
        guard let appSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        else { return nil }
        
        let appDirectory = appSupportDirectory.appendingPathComponent(subsystem)
        
        do {
            try FileManager.default.createDirectory(
                at: appDirectory,
                withIntermediateDirectories: true,
                attributes: nil)
        } catch {
            return nil
        }
        
        return appDirectory.appendingPathComponent(
            String(format: Constants.logFileNameMask, self.jobId.uuidString))
    }
    
    func clearLogFile() {
        fileQueue.async {
            guard let fileURL = self.getLogFileUrl()
            else { return }
            
            do {
                try String().write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                return
            }
        }
    }
    
    func deleteLogFile() {
        guard let fileURL = self.getLogFileUrl()
        else { return }
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: fileURL)
        }
        catch {
            return
        }
    }
    
    // MARK: Private functions

    private func log(
        _ message: String,
        _ level: LogLevel) {
        let timestamp = self.dateFormatter.string(from: Date())
        let consoleMessage = "\(level.rawValue) \(message)"
        let fileMessageMask = "%1$@ \(timestamp)  \(message)"
            
        switch level {
            case .debug:
                print(consoleMessage)
                break
            case .info:
                let infoMessage = String(format: fileMessageMask, Constants.info)
                self.writeToLogFile(infoMessage)
                break
            case .error:
                let errorMessage = String(format: fileMessageMask, Constants.error)
                self.writeToLogFile(errorMessage)
                break
        }
    }
    
    private func writeToLogFile(_ message: String) {
        fileQueue.async {
            guard let logFileUrl = self.getLogFileUrl()
            else { return }
            
            let doesLogFileExist = FileManager.default
                .fileExists(atPath: logFileUrl.path)
            
            if doesLogFileExist {
                self.writeToExistentLogFile(
                    message: message,
                    logFileUrl: logFileUrl)
            }
            else {
                self.writeToNonexistentLogFile(
                    message: message,
                    logFileUrl: logFileUrl)
            }
        }
    }
    
    private func writeToNonexistentLogFile(message: String, logFileUrl: URL) {
        do {
            try message.write(to: logFileUrl, atomically: true, encoding: .utf8)
        } catch {
            return
        }
    }
    
    private func writeToExistentLogFile(message: String, logFileUrl: URL) {
        do {
            let fileHandle = try FileHandle(forWritingTo: logFileUrl)
            
            defer { fileHandle.closeFile() }
            
            fileHandle.seekToEndOfFile()
            
            let logMessage = try self.isLogFileEmpty(fileUrl: logFileUrl)
                ? message
                : "\((Constants.newLine))\(message)"
            
            if let data = logMessage.data(using: .utf8) {
                fileHandle.write(data)
            }
            
            self.trimLogFile(at: logFileUrl)
        } catch {
            return
        }
    }
    
    private func trimLogFile(at fileURL: URL) {
        var recentLines: [String] = []
        
        do {
            guard let stream = InputStream(url: fileURL)
            else { return }
            
            stream.open()
            
            defer { stream.close() }
            
            let bufferSize = 1024
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            defer { buffer.deallocate() }
            
            var partialLine = String()
            
            while stream.hasBytesAvailable {
                let bytesRead = stream.read(buffer, maxLength: bufferSize)
                
                if bytesRead < 0 {
                    throw stream.streamError
                    ?? NSError(domain: Constants.loggerDomainName, code: -1, userInfo: nil)
                }
                
                if bytesRead == 0 { break }
                
                if let chunk = String(bytes: UnsafeBufferPointer(start: buffer, count: bytesRead), encoding: .utf8) {
                    let lines = (partialLine + chunk).split(
                        separator: Constants.newLine,
                        omittingEmptySubsequences: false)
                    partialLine = lines.last.map { String($0) } ?? String()
                    
                    for line in lines.dropLast(1) {
                        recentLines.append(String(line))
                        if recentLines.count > Constants.defaultLogFileLimit {
                            recentLines.removeFirst()
                        }
                    }
                }
            }
            
            if !partialLine.isEmpty {
                recentLines.append(partialLine)
                if recentLines.count > Constants.defaultLogFileLimit {
                    recentLines.removeFirst()
                }
            }
            
            if recentLines.count > Constants.defaultLogFileLimit {
                recentLines = Array(recentLines.suffix(Constants.defaultLogFileLimit))
            }
            
            let trimmedContent = recentLines.joined(separator: Constants.newLine)
            try trimmedContent.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            return
        }
    }
    
    private func isLogFileEmpty(fileUrl: URL) throws -> Bool {
        let fileManager = FileManager.default
        let attribtues = try fileManager.attributesOfItem(atPath: fileUrl.path)
        let fileSize = attribtues[.size] as? Int
        
        return fileSize == 0
    }
}
