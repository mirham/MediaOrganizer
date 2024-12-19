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
    static let dragAndDropTimeToleranceInSeconds: Int = 1
    static let space = "   "
    static let slash = "/"
    static let customTextLimit = 100
    
    // MARK: Settings key names
    static let settingsKeyJobs = "jobs"
    
    // MARK: Window IDs
    static let windowIdJobSettings = "job-settings-view"
    static let windowIdInfo = "info-view"
    
    // MARK: Icons
    static let iconApp = "AppIcon"
    static let iconRun = "play.circle.fill"
    static let iconArrowForward = "arrow.forward"
    static let iconAdd = "plus.circle.fill"
    static let iconRemove = "minus.circle.fill"
    static let iconSettings = "gearshape.2"
    static let iconCheckmark = "checkmark.circle.fill"
    static let iconCircle = "circle"
    static let iconArrowDown = "arrow.down.circle.fill"
    static let iconCheck = "checkmark.circle.fill"
    static let iconEdit = "pencil.circle.fill"
    static let iconFile = "doc.fill"
    
    // MARK: Colors
    static let colorHexSelection = "#244EC9"
    static let colorHexPanelDark = "#313131"
    static let colorHexFileElement = "#681892"
    static let colorHexExifElement = "#093576"
    static let colorHexCustomElement = "#C49518"
    
    // MARK: Regexes
    static let regexLocationInIso6709 = "([+-][0-9.]+)([+-][0-9.]+)"
    static let regexEncodedLocationInIso6709 = "%+09.5f%+010.5f%+.0fCRSWGS_84/"
    
    // MARK: Element names
    static let elInfo = "Info"
    static let elJobSettings = "Job settings"
    static let elGeneral = "General"
    static let elRulesAndActions = "Rules and actions"
    static let elAddJob = "Add job"
    static let elEditJob = "Edit job"
    static let elChoose = "Choose..."
    static let elJobName = "Job name"
    static let elConditions = "Conditions"
    static let elActions = "Actions"
    static let elNoConditions = "No conditions"
    static let elNoActions = "No actions"
    
    // MARK: Masks
    static let maskSource =  "Source: %1$@"
    static let maskOutput =  "Output: %1$@"
    
    // MARK: Toolbars
    static let toolbarRunJobs = "Run all checked jobs"
    static let toolbarAddJob = "Add job"
    static let toolbarRemoveJob = "Remove job"
    static let toolbarAddRule = "Add rule"
    static let toolbarRemoveRule = "Remove rule"
    
    // MARK: Stubs
    static let stubNotSelected = "not selected yet"
    
    // MARK: Hints
    static let hintFolder = "Select a folder..."
    static let hintJobName = "A job name"
    static let hintCustomText = "Custom text"
    
    // MARK: Drag and Drop
    static let ddFolder = "public.file-url"
    
    // MARK: Dialogs
    static let dialogHeaderRemoveJob = "Delete job '%1$@'"
    static let dialogBodyRemoveJob = "This operation cannot be undone. The folders will be preserved."
    static let dialogHeaderRemoveRule = "Delete rule"
    static let dialogBodyRemoveRule = "This operation cannot be undone."
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
