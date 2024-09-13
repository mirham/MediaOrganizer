//
//  Constants.swift
//  MediaOrganizer
//
//  Created by UglyGeorge on 13.09.2024.
//

import Foundation

struct Constants {
    // MARK: Default values
    static let appName = "MirHam Media Organizer"
    static let step: Int = 1
    static let progressBarUpdateInterval: Double = 0.1
    static let threadChunk = 500
    static let minPercentage: Double = 0
    static let maxPercentage: Double = 100
    
    // MARK: Settings key names
    static let settingsKeySourceFolder = "src-folder"
    static let settingsKeyDestinationFolder = "dest-folder"
    
    // MARK: Window IDs
    static let windowIdInfo = "info-view"
    
    // MARK: Element names
    static let elInfo = "Info"
    static let elChoose = "Choose..."
    static let elGenerate = "Generate"
    
    // MARK: Hints
    static let hintFolder = "Select a folder..."
    
    // MARK: Drag and Drop
    static let ddFolder = "public.file-url"
    
    // MARK: About
    static let aboutSupportMail = "bWlyaGFtQGFidi5iZw=="
    static let aboutGitHubLink = "https://github.com/mirham/MediaOrganizer"
    
    static let aboutBackground = "AppInfo"
    
    static let aboutVersionKey = "CFBundleShortVersionString"
    static let aboutGetSupport = "Get support:"
    static let aboutVersion = "Version: %1$@"
    static let aboutMailTo = "mailto:%1$@"
    static let aboutGitHub = "GitHub"
}
