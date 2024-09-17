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
    static let defaultJobName = "New job"
    
    // MARK: Settings key names
    static let settingsKeyJobs = "jobs"
    
    // MARK: Window IDs
    static let windowIdJobSettings = "job-settings-view"
    static let windowIdInfo = "info-view"
    
    // MARK: Icons
    static let iconApp = "AppIcon"
    static let iconArrowForward = "arrow.forward"
    static let iconAdd = "plus.circle.fill"
    static let iconRemove = "minus.circle.fill"
    static let iconSettings = "gearshape.2"
    static let iconCheckmark = "checkmark.circle.fill"
    static let iconCircle = "circle"
    
    // MARK: Element names
    static let elInfo = "Info"
    static let elJobSettings = "Job settings"
    static let elGeneral = "General"
    static let elActionsAndRules = "Actions and rules"
    static let elAddJob = "Add job"
    static let elEditJob = "Edit job"
    static let elChoose = "Choose..."
    static let elJobName = "Job name"
    
    // MARK: Masks
    static let maskSource =  "Source: %1$@"
    static let maskOutput =  "Output: %1$@"
    
    // MARK: Toolbar
    static let toolbarAddJob = "Add job"
    static let toolbarRemoveJob = "Remove job"
    static let toolbarJobSettings = "Job Settings"
    
    // MARK: Stubs
    static let stubNotSelected = "not selected yet"
    
    // MARK: Hints
    static let hintFolder = "Select a folder..."
    static let hintJobName = "A job name"
    
    // MARK: Drag and Drop
    static let ddFolder = "public.file-url"
    
    // MARK: Dialogs
    static let dialogHeaderRemoveJob = "Delete job '%1$@'"
    static let dialogBodyRemoveJob = "This operation cannot be undone. The folders will be preserved."
    static let dialogButtonDelete = "Remove"
    static let dialogButtonCancel = "Cancel"
    
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
